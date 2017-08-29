PhaxMachine.Utils = {
  formatMoney: function(valueInCents){
    var valueString = String(valueInCents);
    while (valueString.length < 3){
      valueString = "0" + valueString;
    }
    var valueChars = valueString.split("");
    valueChars.splice(-2, 0, ".");
    return "$" + valueChars.join("");
  },

  capitalize: function(string){
    chars = string.split('');
    chars[0] = chars[0].toUpperCase();
    return chars.join('');
  }
};
