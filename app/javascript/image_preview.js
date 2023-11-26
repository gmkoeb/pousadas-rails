function displayImagePreview(input) {
  let preview = document.getElementById('image-preview')
  let uploadButton = document.getElementById('upload-picture')
  let file = input.files[0]

  let reader = new FileReader()
  reader.onload = function(e) {
    preview.src = e.target.result
    preview.classList.remove('d-none')
    uploadButton.classList.remove('d-none')
  }

  if (file) {
    reader.readAsDataURL(file)
  }
}