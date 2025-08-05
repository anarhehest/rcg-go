$(document).ready(function () {
  var colorLoop = function () {
    var frame = $(".rcg"); // for Random Color Generator

    function shiftColor() {
      const color = getRandomColor();
      const seconds = 1 + Math.pow(Math.PI, Math.random());

      console.log(seconds);

      frame.css({
        "background-color": color,
        "box-shadow": `0 0 256px 100px ${color}`, // Use the same color for box-shadow
        // making a smooth color changing with a bit random amount of time
        transition: `background-color ${seconds}s ease-in-out, box-shadow ${seconds}s ease-in-out`,
      });

      setTimeout(shiftColor, seconds * 10 ** 3);
    }

    function getRandomColor() {
      // Generate a random integer between 0 and 16777215
      var randomInt = Math.floor(Math.random() * 16777215);
  
      // Convert the integer to hexadecimal and pad with zeros if necessary
      var hexColor = '#' + (randomInt.toString(16)).padStart(6, '0');
  
      console.log(randomInt, hexColor)
      return hexColor;
  }  

    shiftColor();
  };

  colorLoop();
});
