var FileDrop = {
  registerAll: function() {
    var fileDrops = document.querySelectorAll(".file-drop")

    fileDrops.forEach(function(fileDrop) {
      var targetAttr = fileDrop.attributes.getNamedItem("data-target")
      if (targetAttr === null) {
        console.warn("File drop element has no target specified! Skipping.")
        return
      }

      var targetSelector = targetAttr.value
      try {
        var targetElement = document.querySelector(targetSelector)
      }
      catch(e) {
        console.warn(e)
        return
      }
      if (targetElement === null) {
        console.warn("Target element not found for selector (" + targetSelector + ")! Skipping")
        return
      }

      FileDrop.register(fileDrop, targetElement)
    })
  },

  register: function(fileDrop, target) {
    // Need to count dragenter and dragleave events to account for children
    var dragCounter = 0
    var setFileDropClass = function() {
      if (dragCounter === 1) {
        fileDrop.classList.add("active")
      }
      else if (dragCounter === 0) {
        fileDrop.classList.remove("active")
      }
    }
    var handleDragEnter = function(event) {
      event.preventDefault()
      event.stopPropagation()
      event.dataTransfer.dropEffect = "copy"
      dragCounter++
      setFileDropClass()
    }
    var handleDragOver = function(event) {
      event.preventDefault()
      event.stopPropagation()
    }
    var handleDrop = function(event) {
      event.preventDefault()
      event.stopPropagation()
      target.files = event.dataTransfer.files
      dragCounter = 0
      setFileDropClass()
    }
    var handleDragLeave = function(event) {
      event.preventDefault()
      event.stopPropagation()
      dragCounter--
      setFileDropClass()
    }
    fileDrop.addEventListener('dragenter', handleDragEnter)
    fileDrop.addEventListener('dragover', handleDragOver)
    fileDrop.addEventListener('drop', handleDrop)
    fileDrop.addEventListener('dragleave', handleDragLeave)
  }
}

document.addEventListener('DOMContentLoaded', function() {
  FileDrop.registerAll()
})