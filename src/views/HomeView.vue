<script>import axios from "axios";
import json from './processed_dictionary.json'

export default {
  data: function () {
    return {
      message: "Wordle",
      correct: "TORAH",
      currentGuess: '', // model for input box 
      guesses: [],      // holds guesses as arrays of letter objects
      response: '',     // message shown to the user
      count: 0,
      keyboardLetters: [
        [{ char: 'Q', place: 'none' }, { char: 'W', place: 'none' }, { char: 'E', place: 'none' }, { char: 'R', place: 'none' }, { char: 'T', place: 'none' }, { char: 'Y', place: 'none' }, { char: 'U', place: 'none' }, { char: 'I', place: 'none' }, { char: 'O', place: 'none' }, { char: 'P', place: 'none' }],
        [{ char: 'A', place: 'none' }, { char: 'S', place: 'none' }, { char: 'D', place: 'none' }, { char: 'F', place: 'none' }, { char: 'G', place: 'none' }, { char: 'H', place: 'none' }, { char: 'J', place: 'none' }, { char: 'K', place: 'none' }, { char: 'L', place: 'none' }],
        [{ char: 'Z', place: 'none' }, { char: 'X', place: 'none' }, { char: 'C', place: 'none' }, { char: 'V', place: 'none' }, { char: 'B', place: 'none' }, { char: 'N', place: 'none' }, { char: 'M', place: 'none' },]
      ],
      dictionary: json
    };
  },
  created: function () {
  },
  methods: {
    checkGuess: function (guess) {
      guess = guess.toUpperCase();
      if (this.validateGuess(guess)) {
        this.currentGuess = '';
        if (guess === this.correct) {
          this.response = 'You got it!'
        }
        let guessObjects = [];
        let compareCorrect = this.correct.split('') // makes a copy of the correct word to check against
        for (let i in guess) {                      // loops once to find correct letters and remove from word
          guessObjects[i] = { char: guess[i] }
          if (guess[i] == compareCorrect[i]) {
            guessObjects[i].place = 'good'
            compareCorrect.splice(i, 1, ' ')        // sets the compareCorrect letter to ' '
          }
        }
        for (let i in guess) {                      // loops again to check against remaining
          if (
            compareCorrect.includes(guess[i])
          ) {
            guessObjects[i].place = 'okay'
            compareCorrect.splice(compareCorrect.indexOf(guess[i]), 1, ' ')
          } else if (!guessObjects[i].place) {
            guessObjects[i].place = 'none'
          }
        }
        this.guesses.push(guessObjects);
        this.count += 1
        if (this.count >= 6) {
          this.response = `The word is ${this.correct}`;
        }
        this.updateKeyboardLetters(guessObjects);
      }
    },
    validateGuess: function (guess) {
      if (guess.length != 5) {
        this.response = 'Guess must be five letters.';
        return false;
      }
      else if (!this.dictionary[guess[0].toLowerCase()].includes(guess.toLowerCase())) {
        this.response = 'Guess not in dictionary.';
        return false;
      }
      return true;
    },
    addLetter: function (letter) {
      this.currentGuess = this.currentGuess + letter
    },
    updateKeyboardLetters: function (guessObjects) {
      guessObjects.forEach(guessObject => {
        this.keyboardLetters.forEach(row => {
          if (row.find(item => item.char === guessObject.char)) {
            let thisKey = row.find(item => item.char === guessObject.char)
            if (thisKey.place === 'none') {
              thisKey.place = guessObject.place
            } else if (thisKey.place === 'okay' && guessObject.place == 'good') {
              thisKey.place = guessObject.place
            }
          }
        })
      }
      )
    }
  }
}
</script>

<template>
  <div class="home">
    <h1>{{ message }}</h1>
    <div v-for="guess in guesses" class="letter">
      <h2> <span v-for="letter in guess" v-bind:class="`letter-${letter.place}`">&nbsp;{{ letter.char }}&nbsp;</span>
      </h2>
    </div>
    <p>{{ response }}</p>
    <div v-for="line in keyboardLetters">
      <button v-for="letter in line" v-bind:class="`letter letter-${letter.place}`"
        v-on:click="addLetter(letter.char)">{{
          letter.char
        }}</button>
    </div>
    <form v-on:submit.prevent>
      <input v-model="currentGuess" />
      <button v-on:click="checkGuess(currentGuess)" type="submit">Enter</button>
    </form>
  </div>
</template>

<style>
.letter {
  color: white;
  font-weight: bold;
}

.letter-good {
  background: green;
}

.letter-okay {
  background: gold;
}

.letter-none {
  background: gray;
}

h2 {
  line-height: 0.75em;
}
</style>