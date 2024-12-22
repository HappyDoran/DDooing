// server.js

const express = require("express");
const { GoogleAuth } = require("google-auth-library");

const app = express();
const PORT = process.env.PORT || 3000;

// 서비스 계정 키 파일 경로
const KEY_FILE = "./serviceAccountKey.json"; // 실제 경로로 수정

// 액세스 토큰을 요청하는 API 엔드포인트
app.get("/getAccessToken", async (req, res) => {
  const auth = new GoogleAuth({
    keyFile: KEY_FILE,
    scopes: ["https://www.googleapis.com/auth/firebase.messaging"], // 필요한 스코프
  });

  try {
    const client = await auth.getClient();
    const accessToken = await client.getAccessToken();
    console.log("Access Token:", accessToken.token);
    res.send(accessToken.token);
  } catch (error) {
    console.error("Error fetching access token:", error);
    res.status(500).send("Error fetching access token");
  }
});

// 서버 시작
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
