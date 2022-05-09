<script>
import { isLabeledStatement } from "@babel/types";
import axios from "axios";
import dict from './processed_dictionary.json'

export default {
  data: function () {
    return {
      message: "(not) Wordle",
      correct: "WORDS",
      currentGuess: '', // model for input box 
      guesses: [],      // holds guesses as arrays of letter objects
      response: '',     // message shown to the user
      count: 0,
      keyboardLetters: [
        [{ char: 'Q', place: 'light' }, { char: 'W', place: 'light' }, { char: 'E', place: 'light' }, { char: 'R', place: 'light' }, { char: 'T', place: 'light' }, { char: 'Y', place: 'light' }, { char: 'U', place: 'light' }, { char: 'I', place: 'light' }, { char: 'O', place: 'light' }, { char: 'P', place: 'light' }],
        [{ char: 'A', place: 'light' }, { char: 'S', place: 'light' }, { char: 'D', place: 'light' }, { char: 'F', place: 'light' }, { char: 'G', place: 'light' }, { char: 'H', place: 'light' }, { char: 'J', place: 'light' }, { char: 'K', place: 'light' }, { char: 'L', place: 'light' }],
        [{ char: 'Z', place: 'light' }, { char: 'X', place: 'light' }, { char: 'C', place: 'light' }, { char: 'V', place: 'light' }, { char: 'B', place: 'light' }, { char: 'N', place: 'light' }, { char: 'M', place: 'light' },]
      ],
      dictionary: dict
    };
  },
  mounted: function () {
    this.getCorrect()
  },
  methods: {
    getCorrect: function () {
      const i = Math.floor(Math.random() * this.dictionary.length)
      this.correct = this.dictionary[i].toUpperCase()
      console.log(this.correct)
    },
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
          this.response = `The word is ${this.correct}`;
        }
        this.updateKeyboard(guessObjects);
      }
    },
    validateGuess: function (guess) {
      if (guess.length != 5) {
        this.response = 'Guess must be five letters.';
        return false;
      }
      else if (!this.dictionary.includes(guess.toLowerCase())) {
        this.response = 'Guess not in dictionary.';
        return false;
      }
      this.response = '';
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
            if (thisKey.place === 'light') {
              thisKey.place = guessObject.place
            } else if (thisKey.place === 'warning' && guessObject.place == 'success') {
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
  <div class="mx-auto" style="max-width: 640px">
    <h1>{{ message }}</h1>
    <div class="row" v-for="guess in guesses">
      <h2 class="display-5 my-0"><span v-for="letter in guess" v-bind:class="`badge bg-${letter.place} m-1 px-0`"
          style="width: 1.75em">{{
              letter.char
          }}</span>
      </h2>
    </div>
    <p>{{ response }}</p>
    <div v-for="line in keyboardLetters">
      <button v-for="letter in line" v-bind:class="`btn btn-${letter.place} m-1 px-0`" style="width: 1.75em"
        v-on:click="addLetter(letter.char)">{{
            letter.char
        }}</button>
    </div>
    <form v-on:submit.prevent>
      <button type="submit" v-on:click="checkGuess(currentGuess)" class="btn btn-light m-1 px-0"
        style="width: 3em">Enter</button>
      <input v-model="currentGuess" class="m-1" />
      <button class="btn btn-light m-1 px-0" v-on:click="backspace()" style="width: 3em">&#9003;</button>
    </form>
  </div>
</template>

<style>
</style>