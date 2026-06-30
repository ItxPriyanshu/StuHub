const axios = require("axios");

const sendEmail = async ({
  to,
  subject,
  text,
  html,
}) => {
  await axios.post(
    "https://api.brevo.com/v3/smtp/email",
    {
      sender: {
        name: "StuHub",
        email: process.env.SENDER_EMAIL,
      },

      to: [
        {
          email: to,
        },
      ],

      subject,

      htmlContent: html,

      textContent: text,
    },

    {
      headers: {
        "accept": "application/json",
        "api-key": process.env.BREVO_API_KEY,
        "content-type": "application/json",
      },
    }
  );
};

module.exports = sendEmail;