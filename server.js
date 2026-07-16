import express from "express";
import cors from "cors";
import multer from "multer";
import dotenv from "dotenv";
import { exec } from "child_process";
import fs from "fs";
import path from "path";
import plist from "plist";
import mongoose from "mongoose";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGO_URL, { useNewUrlParser: true, useUnifiedTopology: true });

// Storage folders
const IPA_DIR = "./storage/ipas/";
const SIGNED_DIR = "./storage/signed/";
const CERT_DIR = "./storage/certs/";

[IPA_DIR, SIGNED_DIR, CERT_DIR].forEach(dir => {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
});

// Multer upload
const upload = multer({ dest: "uploads/" });

// MongoDB Models
const AppModel = mongoose.model("App", new mongoose.Schema({
  name: String,
  bundleId: String,
  icon: String,
  description: String,
  category: String,
  versions: [
    {
      version: String,
      ipaPath: String,
      size: Number,
      changelog: String
    }
  ]
}));

const CertModel = mongoose.model("Cert", new mongoose.Schema({
  name: String,
  type: String,
  p12Path: String,
  password: String
}));

// ----------------------
// IPA LIBRARY ROUTES
// ----------------------

app.get("/api/apps", async (req, res) => {
  const search = req.query.search || "";
  const apps = await AppModel.find({
    name: { $regex: search, $options: "i" }
  });
  res.json(apps);
});

app.get("/api/apps/:id", async (req, res) => {
  const appData = await AppModel.findById(req.params.id);
  res.json(appData);
});

app.post("/api/apps", upload.single("icon"), async (req, res) => {
  const { name, bundleId, description, category } = req.body;

  const newApp = new AppModel({
    name,
    bundleId,
    description,
    category,
    icon: req.file ? req.file.path : null,
    versions: []
  });

  await newApp.save();
  res.json({ success: true, id: newApp._id });
});

app.post("/api/apps/:id/versions", upload.single("ipa"), async (req, res) => {
  const appData = await AppModel.findById(req.params.id);

  const ipaPath = IPA_DIR + req.file.filename + ".ipa";
  fs.renameSync(req.file.path, ipaPath);

  appData.versions.push({
    version: req.body.version,
    ipaPath,
    size: req.file.size,
    changelog: req.body.changelog || ""
  });

  await appData.save();
  res.json({ success: true });
});

// ----------------------
// CERTIFICATE ROUTES
// ----------------------

app.get("/api/certs", async (req, res) => {
  const certs = await CertModel.find();
  res.json(certs);
});

app.post("/api/certs", upload.single("p12"), async (req, res) => {
  const { name, type, password } = req.body;

  const p12Path = CERT_DIR + req.file.filename + ".p12";
  fs.renameSync(req.file.path, p12Path);

  const cert = new CertModel({
    name,
    type,
    password,
    p12Path
  });

  await cert.save();
  res.json({ success: true });
});

app.delete("/api/certs/:id", async (req, res) => {
  await CertModel.findByIdAndDelete(req.params.id);
  res.json({ success: true });
});

// ----------------------
// SIGNING ROUTE (zsign)
// ----------------------

app.post("/api/sign", upload.single("ipa"), async (req, res) => {
  const { ipaId, certId, mode, flags } = req.body;

  let ipaPath;

  if (ipaId) {
    const appData = await AppModel.findById(ipaId);
    ipaPath = appData.versions[appData.versions.length - 1].ipaPath;
  } else {
    ipaPath = IPA_DIR + req.file.filename + ".ipa";
    fs.renameSync(req.file.path, ipaPath);
  }

  const cert = await CertModel.findById(certId);

  const outputPath = SIGNED_DIR + "signed_" + Date.now() + ".ipa";

  const zsignCmd = `
    zsign -k ${cert.p12Path} -p "${cert.password}" \
    -m ${process.env.DEFAULT_MOBILEPROVISION} \
    -o ${outputPath} \
    ${ipaPath}
  `;

  exec(zsignCmd, (err, stdout, stderr) => {
    if (err) {
      return res.json({ error: stderr });
    }

    const manifest = plist.build({
      items: [
        {
          assets: [
            {
              kind: "software-package",
              url: process.env.BASE_URL + "/" + outputPath
            }
          ],
          metadata: {
            bundle-identifier: "signed.app",
            bundle-version: "1.0",
            kind: "software",
            title: "Signed IPA"
          }
        }
      ]
    });

    const manifestPath = SIGNED_DIR + "manifest_" + Date.now() + ".plist";
    fs.writeFileSync(manifestPath, manifest);

    res.json({
      signedIpaUrl: process.env.BASE_URL + "/" + outputPath,
      manifestUrl: process.env.BASE_URL + "/" + manifestPath,
      otaUrl: `itms-services://?action=download-manifest&url=${process.env.BASE_URL}/${manifestPath}`
    });
  });
});

// ----------------------
// START SERVER
// ----------------------

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log("SideSigner backend running on port " + PORT);
});
