# Starter apps for AIProxy

Use these apps as a jumping off point to build your own experiences using AIProxy. Sample apps are organized by services (for ex. OpenAI, Anthropic etc.). Each sample app has a placeholder to add your AIProxy constants (see AppConstants.swift). The apps all use either [AIProxySwift](https://github.com/lzell/AIProxySwift) or [SwiftOpenAI](https://github.com/jamesrochabrun/SwiftOpenAI) to implement API calls.

### Instructions to build and run

1. Watch [the AIProxy integration video](https://www.aiproxy.pro/docs/integration-guide.html) 
2. Replace the constants in `AppConstants.swift` files with the snippet you receive from the AIProxy dashboard in step 1
3. Change the bundler identifier of the sample app to match the App ID you created in step 1
4. Add an AIPROXY_DEVICE_CHECK_BYPASS env variable to Xcode. This is necessary for the iOS simulator to communicate with the AIProxy backend. Type **cmd-shift-comma** to open up the "Edit Schemes" menu. Select Run in the sidebar, then select Arguments from the top nav. Add to the "Environment Variables" section an env variable with name AIPROXY_DEVICE_CHECK_BYPASS and value displayed on the key details screen.


### OpenAI Sample apps

- **AIColorPalette** - A color palette generator that uses an image as input.
- **Chat** - A basic chat application and interface. Includes streaming responses and ability to stop stream.
- **Image Classifier** - An image classification app that identifies plants and provides a link to Wikipedia.
- **Transriber** - An app that transcribes audio recorded using the device microphone.
- **Translator** - A simple English to Spanish translation app with text to speech.
- **Trivia Game** - A trivia game that uses GPT to generate multiple choice questions from a JSON response.
- **Stickers** - An app that turns a prompt into a kawaii style sticker and extracts the foreground/background using Vision.

### Anthropic Sample apps

- **EmojiPuzzleMaker** - Generate emoji puzzles using Anthropic's Claude 3.5 Sonnet API.