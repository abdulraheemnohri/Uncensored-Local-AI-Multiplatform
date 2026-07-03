# Changelog

All notable changes to this project will be documented in this file.

## [2.1.0] - 2026-07-03

### Added
- **Voice Interaction**: Full voice input and output support with speech-to-text and text-to-speech capabilities
  - Voice recognition service for hands-free input
  - Text-to-speech service for audio responses
  - Voice chat screen with microphone controls
  - Adjustable speech rate, volume, and pitch settings
- **AI Agent Mode**: Specialized AI personas for different use cases
  - Researcher agent for deep analysis and research
  - Writer agent for creative content generation
  - Coder agent for code generation and analysis
  - Analyst agent for data analysis and problem-solving
  - Custom agent creation and management
  - Agent-specific system prompts and parameters
- **Web Search Integration**: Basic web search functionality
  - Search the web directly from the app
  - Open search results in external browser
  - AI-powered search result analysis
- **New Dependencies**: Added packages for voice, web, and agent features

### Changed
- **Version Bump**: Updated app version to v2.1.0
- **Enhanced Features**: Expanded functionality with new interaction modes

### Fixed
- All previous fixes from v2.0.0 maintained

---

## [2.0.0] - 2026-04-23

### Added
- Global Loading Overlay: Real-time feedback during large model imports with dynamic pulse messages.
- Deduplication Logic: Prevents duplicate model cards and synchronized loading states for models with the same filename.
- Log Viewer: New Logs screen accessible from the drawer to track and share system logs for troubleshooting.
- RAM/Size Validation: Safety dialogs that warn users before importing or loading models that exceed device resource thresholds.
- Manual Cache Management: Clear Temporary Cache button in settings to reclaim storage from interrupted imports.

### Changed
- Optimized Model Imports: Switched from slow stream-copying to instantaneous file-renaming (moving) for local file imports.
- Startup Resilience: App no longer crashes on splash screen if the Local API port is already in use.
- UI Improvements: Hidden 0 percentage text on local imports for a cleaner indeterminate loading state.
- Version Bump: Updated app version to v2.0.0.

### Fixed
- Ghost Writing: Resolved issue where AI generation continued after tapping the Stop button.
- Temporary Cache Bloat: Automatic cleanup of massive temporary files after successful model imports.
- Address in Use Error: Handled socket exceptions in LocalApiServerService.

---
