/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import textToSpeech from "@google-cloud/text-to-speech";
import { google } from "@google-cloud/text-to-speech/build/protos/protos";

const PROJECT_ID = "meditation-maker";

admin.initializeApp({
  projectId: PROJECT_ID,
  credential: admin.credential.applicationDefault(),
});

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

export const synthesize = functions.https.onCall(async (data, context) => {
  const client = new textToSpeech.TextToSpeechClient({
    projectId: PROJECT_ID,
  });

  const [response] = await client.synthesizeSpeech(
    {
      input: { ssml: data.ssml },
      voice: {
        languageCode: "en-US",
        ssmlGender: google.cloud.texttospeech.v1.SsmlVoiceGender.NEUTRAL,
      },
      audioConfig: {
        audioEncoding: google.cloud.texttospeech.v1.AudioEncoding.MP3,
      },
    },
    {
      otherArgs: {
        auth: (
          await admin.credential.applicationDefault().getAccessToken()
        ).access_token,
      },
    }
  );

  const result = JSON.stringify(response);

  return {
    jsonString: result,
  };
});
