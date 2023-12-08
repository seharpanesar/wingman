from flask import Flask, request, jsonify
from PIL import Image
import pytesseract
import io
from openai import OpenAI
import os

# THIS KEY HAS BEEN INVALIDATED FOR SECURITY PURPOSES
client = OpenAI(api_key='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')

app = Flask(__name__)


@app.route('/upload', methods=['POST'])
def upload_file():
    image_bytes = request.get_data()
    # Accessing the 'Response-Style' header
    response_style = request.headers.get('Response-Style')

    if response_style is  None:
        response_style = "funny"

    if not image_bytes:
        return jsonify({'error': 'No data received'}), 400
    try:
        # load image from bytes 
        image = Image.open(io.BytesIO(image_bytes))
        
        # convert the image to grayscale
        image = image.convert("L")

        # extract text
        text = pytesseract.image_to_string(image)

        system_message = f"You are a witty chatbot who takes in conversation history and generates a pickup line / charismatic response. Feel free to add emojis sparingly." \
                         f"Try to make your response {response_style}." \
                         f"Ignore the timestamps in your response. There may be some typos / garbled text since pytessearct was used to extract text"
        prompt = f"The following text was extracted from a text message screenshot\"{text}\"." \
                 f"Based on this conversation please create a line that is a {response_style} response style. Respond only with the pickup line / charismatic response (no formatting, eg. no quotation marks or bold or italics). "
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": system_message},
                {"role": "user", "content": prompt}
            ],
            temperature=1,
            max_tokens=256,
            top_p=1,
            frequency_penalty=0,
            presence_penalty=0
        )
        response_message = response.choices[0].message.content
        return jsonify({'chatgpt_response': response_message}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
