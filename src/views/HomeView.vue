<!-- 
There is a correct word
Allow user to enter a word
Provide feedback as to whether that word is correct
Guess must be five letters long

Allow user to enter more guesses (up to six)
Provide feedback as to whether each letter is correct

Only allow guesses that are actually words (API call)


 -->

<script>
export default {
  data: function () {
    return {
      message: "Wordle",
      correct: "PRANK",
      currentGuess: '',
      guesses: [],
      response: '',
      count: 0
    };
  },
  created: function () { },
  methods: {
    checkGuess: function (guess) {
      if (this.validateGuess(guess)) {
        this.guesses.push(guess.toUpperCase().split(''));
        this.count += 1
        if (guess.toUpperCase() != this.correct) {
          this.response = 'Incorrect.'
        } else {
          this.response = 'You got it!'
        }
      }
    },
    validateGuess: function (guess) {
      if (this.count >= 6) {
        this.response = `The word is ${guess}`;
        return false;
      } else if (guess.length != 5) {
        this.response = 'Guess must be five letters.';
        return false;
      } else {
        return true;
      }
    }
  }
}
</script>

<template>
  <div class="home">
    <h1>{{ message }}</h1>
    <div v-for="guess in guesses">
      <span v-for="letter in guess">{{ letter }}&nbsp;</span>
    </div>
    <p>{{ response }}</p>
    <input v-model="currentGuess" />
    <button v-on:click="checkGuess(currentGuess)" type="button">Enter</button>
  </div>
</template>

<style></style>