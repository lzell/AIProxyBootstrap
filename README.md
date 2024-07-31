# Starter apps for AIProxy, using the SwiftOpenAI library

Use these apps as a jumping off point to build your own OpenAI experiences on iOS. There are
six apps, each with a placeholder to add your AIProxy constants (see AppConstants.swift). The
apps all use the [SwiftOpenAI](https://github.com/jamesrochabrun/SwiftOpenAI) community package
to implement API calls.

### Instructions to build and run

1. Watch [the AIProxy integration video](https://www.aiproxy.pro/docs/integration-guide.html) 
2. Replace the constants in `AppConstants.swift` files with the snippet you receive from the AIProxy dashboard in step 1
3. Change the bundler identifier of the sample app to match the App ID you created in step 1

### Sample apps

- **Chat** - A basic chat application and interface. Includes streaming responses and ability to stop stream.
- **Image Classifier** - An image classification app that identifies plants and provides a link to Wikipedia.
- **Transriber** - An app that transcribes audio recorded using the device microphone.
- **Translator** - A simple English to Spanish translation app with text to speech.
- **Trivia Game** - A trivia game that uses GPT to generate multiple choice questions from a JSON response.
- **Stickers** - An app that turns a prompt into a kawaii style sticker and extracts the foreground/background using Vision.
