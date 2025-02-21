import cv2
import pytesseract
from pytesseract import Output
import imutils

# Load the image
image = cv2.imread('card_images/firion_0_sleeved.jpg')
if image is None:
    print("Error: Image not found.")
    exit()

# gray image
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# use laplacian method
laplacian = cv2.Laplacian(gray, cv2.CV_64F)
variance = laplacian.var()
# low variance = blurry

if variance < 100.0:
    print(variance)
    print("[INFO] image is blurry")
    exit()
else:
    print(variance)
    print("[INFO] image is fine")

# Convert image to RGB
rgb_image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

# Perform orientation detection
osd_data = pytesseract.image_to_osd(rgb_image, output_type=Output.DICT)
rotation_angle = osd_data.get('rotate', 0)
print("[INFO] detected orientation: {}".format(
	osd_data["orientation"]))
print("[INFO] rotate by {} degrees to correct".format(
	osd_data["rotate"]))
print("[INFO] detected script: {}".format(osd_data["script"]))

# Rotate image to correct orientation
# corrected_image = imutils.rotate_bound(image, angle=osd_data["rotate"])

# # Display the corrected image
# cv2.imshow('Corrected Image', corrected_image)
# cv2.waitKey(0)
# cv2.destroyAllWindows()

# # Save the corrected image
# cv2.imwrite('corrected_image.jpg', corrected_image)
