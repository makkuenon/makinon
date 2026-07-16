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

const CertModel = mongoose.model("
