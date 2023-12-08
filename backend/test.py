import requests


# url = 'https://cs-536-project.ue.r.appspot.com/upload'
# url = 'http://127.0.0.1:5000/upload'
# with open('sc.webp', 'rb') as image_file:
#     image_bytes = image_file.read()
# response = requests.post(url, data=image_bytes)
# print(response.text)

def test_api_with_image(image_path, response_style, url):
    with open(image_path, 'rb') as image_file:
        image_bytes = image_file.read()
    headers = {
        "Content-Type": "application/octet-stream",
        "Response-Style": response_style
    }
    response = requests.post(url, data=image_bytes, headers=headers)
    return response


# Usage example
url = 'https://cs536-jytfyonh5q-ue.a.run.app/upload'
image_path = './test_screenshot.png'
response_style = 'funny'

response = test_api_with_image(image_path, response_style, url)
print(response.text)