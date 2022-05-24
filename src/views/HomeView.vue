<script>
import validGuesses from '../assets/valid_guesses.json'
import validSolutions from '../assets/valid_solutions.json'

export default {
  data: function () {
    return {
      message: "(not) Wordle",
      correct: "WORDS",
      currentGuess: '', // model for input box 
      guesses: [],      // holds guesses as arrays of letter objects
      notify: '',     // message shown to the user
      count: 0,
      default: 'light',
      keyboardLetters: [
        [{ char: 'Q' }, { char: 'W' }, { char: 'E' }, { char: 'R' }, { char: 'T' }, { char: 'Y' }, { char: 'U' }, { char: 'I' }, { char: 'O' }, { char: 'P' }],
        [{ char: 'A' }, { char: 'S' }, { char: 'D' }, { char: 'F' }, { char: 'G' }, { char: 'H' }, { char: 'J' }, { char: 'K' }, { char: 'L' }],
        [{ char: 'Z' }, { char: 'X' }, { char: 'C' }, { char: 'V' }, { char: 'B' }, { char: 'N' }, { char: 'M' }]
      ],
    };
  },
  mounted: function () {
    this.setKeyboard()
    this.getCorrect()
  },
  methods: {
    getCorrect: function () {
      const i = Math.floor(Math.random() * validSolutions.length)
      this.correct = validSolutions[i].toUpperCase()
      console.log(this.correct)
    },
    checkGuess: function (guess) {
      guess = guess.toUpperCase();
      if (this.validateGuess(guess)) {
        this.currentGuess = '';
        if (guess === this.correct) {
          this.notify = 'You got it!'
        }
        let guessObjects = [];
        let compareCorrect = this.correct.split('') // makes a copy of the correct word to check against
        for (let i in guess) {                      // loops once to find correct letters and remove from word
          guessObjects[i] = { char: guess[i] }
          if (guess[i] == compareCorrect[i]) {
            guessObjects[i].place = 'success'
            compareCorrect.splice(i, 1, ' ')        // sets the compareCorrect letter to ' '
            console.log(guess[i] + ' correct')
          }
        }
        for (let i in guess) {                      // loops again to check against remaining
          if (
            compareCorrect.includes(guess[i]) && guessObjects[i].place != 'success'
          ) {
            guessObjects[i].place = 'warning'
            compareCorrect.splice(compareCorrect.indexOf(guess[i]), 1, ' ')
            console.log(guess[i] + ' close')
          } else if (!guessObjects[i].place) {
            guessObjects[i].place = 'secondary'
            console.log(guess[i] + ' wrong')
          }
        }
        this.guesses.push(guessObjects);
        this.count += 1
        if (this.count >= 6 && guess != this.correct) {
          this.notify = `The word is ${this.correct}`;
        }
        this.updateKeyboard(guessObjects);
      }
    },
    validateGuess: function (guess) {
      if (guess.length != 5) {
        this.notify = 'Guess must be five letters.';
        return false;
      }
      else if (
        !validGuesses.includes(guess.toLowerCase())
        && !validSolutions.includes(guess.toLowerCase())) {
        this.notify = 'Guess not in dictionary.';
        return false;
      }
      this.notify = '';
      return true;
    },
    addLetter: function (letter) {
      this.currentGuess = this.currentGuess + letter
    },
    backspace: function () {
      this.currentGuess = this.currentGuess.slice(0, -1)
    },
    updateKeyboard: function (guessObjects) {
      guessObjects.forEach(guessObject => {
        this.keyboardLetters.forEach(row => {
          if (row.find(item => item.char === guessObject.char)) {
            let thisKey = row.find(item => item.char === guessObject.char)
            if (thisKey.place === this.default) {
              thisKey.place = guessObject.place
            } else if (thisKey.place === 'warning' && guessObject.place == 'success') {
              thisKey.place = guessObject.place
            }
          }
        })
      }
      )
    },
    newGame: function () {
      this.count = 0
      this.guesses = []
      this.notify = ''
      this.setKeyboard()
      this.getCorrect()
    },
    changeDefault: function () {
      this.default = this.default === 'light' ? 'dark' : 'light'
      console.log(this.default)
    },
    setKeyboard: function () {
      this.keyboardLetters.forEach(row => {
        row.forEach(letter => { letter.place = this.default })
      })
    }
  }
}
</script>

<template>
  <div class="mx-auto" style="max-width: 640px; min-width: 400px; text-align: center;">
    <!-- <button v-on:click="changeDefault">CHANGE TO DARK</button> -->
    <div id="header">
      <h1>{{ message }} <button class="btn btn-light btn-sm" v-on:click="newGame()">&#8635;</button></h1>
    </div>

    <div class="row" v-for="guess in guesses" id="guesses">
      <h2 class="display-4 my-0"><span v-for="letter in guess" v-bind:class="`badge bg-${letter.place} m-1 px-0`"
          style="width: 1.75em">{{
              letter.char
          }}</span>
      </h2>
    </div>

    <div id="notification">
      <p>{{ notify }}</p>
    </div>

    <div id="keyboard">
      <div v-for="line in keyboardLetters">
        <button v-for="letter in line" v-bind:class="`btn btn-${letter.place} m-1 px-0`" style="width: 1.75em"
          v-on:click="addLetter(letter.char)">{{
              letter.char
          }}</button>
      </div>

      <div class="row" id="controls">
        <form v-on:submit.prevent>
          <button type="submit" v-on:click="checkGuess(currentGuess)" class="btn btn-light m-1 px-0"
            style="width: 3em">Enter</button>
          <input v-model="currentGuess" style="font-size: large" />
          <button class="btn btn-light m-1 px-0" v-on:click="backspace()" style="width: 3em">&#9003;</button>
        </form>
      </div>
    </div>
  </div>
</template>

<style lang="scss">
#game {
  .btn-light {
    background-color: #d3d6da;
  }
}
</style>