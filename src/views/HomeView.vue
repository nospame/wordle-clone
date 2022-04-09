<!-- 
There is a correct word
Allow user to enter a word
Provide feedback as to whether that word is correct
Guess must be five letters long

Allow user to enter more guesses (up to six)
Provide feedback as to whether each letter is correct

Only allow guesses that are actually words (API call)

Make each guess an object within an array, i.e.
[ {letter: P, place: good}, 
{letter: A, place: okay}, 
{letter: R, place: okay},
{letter: T, place: bad},
{letter: Y, place: bad}   ]

Loop through every letter to see if they are correct (this takes precedence)
For each letter that is not correct, see if it exists but is in the wrong place

 -->

<script>import axios from "axios";

export default {
  data: function () {
    return {
      message: "Wordle",
      correct: "ABCDE",
      currentGuess: '',
      guesses: [],
      response: '',
      count: 0
    };
  },
  created: function () { },
  methods: {
    checkGuess: function (guess) {
      guess = guess.toUpperCase();
      if (this.validateGuess(guess)) {
        this.currentGuess = '';
        if (guess === this.correct) {
          this.response = 'You got it!'
        }
        let guessObject = [];
        for (let i in guess) {
          guessObject[i] = { letter: guess[i] }
          if (guess[i] == this.correct[i]) {
            guessObject[i].place = 'good'
          } else if (
            this.correct.includes(guess[i]) &&
            this.correct[i] != guess[i]
          ) {
            guessObject[i].place = 'okay'
          } else {
            guessObject[i].place = 'bad'
          }
        }
        this.guesses.push(guessObject);
        console.log(this.guesses);
        this.count += 1
        if (this.count >= 6) {
          this.response = `The word is ${this.correct}`;
        }
      }
    },
    validateGuess: function (guess) {
      if (guess.length != 5) {
        this.response = 'Guess must be five letters.';
        return false;
        // } else {
        //   axios.get(/* base url */ + guess)
        //   .then(response => {
        //     if (response.data[0] == '') {
        //       return false
        //     }
        //     console.log(response.data);
        //   })
      }
      return true;
    }
  }
}
</script>

<template>
  <div class="home">
    <h1>{{ message }}</h1>
    <div v-for="guess in guesses" class="word-guess">
      <span
        v-for="letter in guess"
        v-bind:class="`letter-${letter.place}`"
      >&nbsp;{{ letter.letter }}&nbsp;</span>
    </div>
    <p>{{ response }}</p>
    <input v-model="currentGuess" />
    <button v-on:click="checkGuess(currentGuess)" type="button">Enter</button>
  </div>
</template>

<style>
.word-guess {
  color: white;
  font-weight: bold;
}

.letter-good {
  background: green;
}

.letter-okay {
  background: gold;
}

.letter-bad {
  background: gray;
}
</style>