# Code Fixer and Generator Agents

This directory contains autonomous agents for code fixing and generation.

## Agents

### Code Fixer Agent (`code-fixer.yml`)

Autonomously identifies and fixes code issues in your repository.

**Features:**
- Scans repository for common code issues
- Generates automated fixes
- Creates pull requests with fixes
- Supports multiple languages (Swift, Python, JavaScript, etc.)

**Triggers:**
- Pull requests (opened, synchronized)
- Issues (opened)

### Code Generator Agent (`code-generator.yml`)

Autonomously generates code based on requirements and patterns.

**Features:**
- Parses requirements from issues and PRs
- Generates code from templates
- Supports multiple languages
- Formats generated code automatically
- Creates pull requests with generated code

**Triggers:**
- Issues (opened, labeled)
- Pull requests (opened)

## Configuration

Both agents require the following permissions:
- `contents: write` - To create commits and branches
- `pull-requests: write` - To create and update PRs
- `issues: write` - To update issues

## Usage

### Code Fixer
The agent runs automatically when:
1. A new pull request is opened
2. A pull request is updated
3. An issue is created

It will analyze the code and create a new PR with fixes if issues are found.

### Code Generator
The agent runs automatically when:
1. A new issue is created
2. An issue is labeled
3. A new pull request is opened

Add labels like `generate-code`, `feature-request`, or `implementation` to trigger code generation.

## Supported Languages

- **Swift** (46.2% of repo)
- **HTML** (25.1% of repo)
- **Python** (15.6% of repo)
- **JavaScript** (9.6% of repo)
- **CMake** (3.5% of repo)

## Best Practices

1. **Code Fixer**: Review automated fixes before merging
2. **Code Generator**: Provide clear requirements in issue descriptions
3. Both agents follow repository conventions and patterns
4. Generated code is tested and formatted before PR creation

## Customization

Edit the workflow files to:
- Change trigger conditions
- Add language-specific rules
- Modify PR templates
- Configure formatting options

## Monitoring

Check the "Actions" tab in your repository to:
- View agent execution logs
- Monitor code fixes and generation
- Debug any issues
