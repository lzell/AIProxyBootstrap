# Starter apps for AIProxy

Use these apps as a jumping off point to build your own experiences using AIProxy. Sample apps are organized by services (for ex. OpenAI, Anthropic etc.). Each sample app has a placeholder to add your AIProxy constants (see AppConstants.swift). The apps all use [AIProxySwift](https://github.com/lzell/AIProxySwift) to implement API calls.

### Instructions to build and run

1. Watch [the AIProxy bootstrap walkthrough video](https://www.youtube.com/watch?v=ohsN9awCzw4)
2. Replace the constants in `AppConstants.swift` files with the snippet you receive from the AIProxy dashboard in step 1
3. Change the bundler identifier of the sample app to match the App ID you created in step 1
4. Add an AIPROXY_DEVICE_CHECK_BYPASS env variable to Xcode. This is necessary for the iOS simulator to communicate with the AIProxy backend. Type **cmd-shift-comma** to open up the "Edit Schemes" menu. Select Run in the sidebar, then select Arguments from the top nav. Add to the "Environment Variables" section an env variable with name AIPROXY_DEVICE_CHECK_BYPASS and value displayed on the key details screen.

### Quickstart apps

- **AIProxyAnthropic** - An Anthropic app that generates a message.
- **AIProxyDeepL** - A DeepL app that translates input text to Spanish.
- **AIProxyOpenAI** - An OpenAI app with chat, DALLE, and vision.
- **AIProxyReplicate** - A Replicate app with Stable Diffusion XL.
- **AIProxyGroq** - A Groq app with chat completion and streaming chat completion examples.
- **AIProxyStability** - A Stability AI app that generates an image.
- **AIProxyTogetherAI** - A Together AI app with examples for chat, streaming chat, and JSON response.

### Playground apps

- **FilmFinder** - A movie recommendation app that uses Groq and TMDB (requires Xcode 16).
- **PuLIDDemo** - An image generator app that uses PuLID on Replicate (requires Xcode 16).
- **AIColorPalette** - An OpenAI color palette generator that uses an image as input (requires Xcode 16).
- **Chat** - A basic chat application and interface with OpenAI. Includes streaming responses and ability to stop stream.
- **Image Classifier** - An OpenAI image classification app that identifies plants and provides a link to Wikipedia.
- **Transriber** - An OpenAI app that transcribes audio recorded using the device microphone.
- **Translator** - A simple English to Spanish translation app with text to speech using OpenAI.
- **Trivia Game** - A trivia game that uses GPT to generate multiple choice questions from a JSON response.
- **Stickers** - An OpenAI app that turns a prompt into a kawaii style sticker and extracts the foreground/background using Vision.
- **EmojiPuzzleMaker** - Generate emoji puzzles using Anthropic's Claude 3.5 Sonnet API.
