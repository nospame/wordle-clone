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
      guess: '',
      response: ''
    };
  },
  created: function () { },
  methods: {
    checkGuess: function () {
      if (this.guess.length != 5) {
        this.response = 'Guess must be five letters.'
      } else if (this.guess.toUpperCase() != this.correct) {
        this.response = 'Incorrect.'
      } else {
        this.response = 'You got it!'
      }
    },
  }
}
</script>

<template>
  <div class="home">
    <h1>{{ message }}</h1>
    <!-- <div v-for="guess in guesses">
      <h2>{{ guess }}</h2>
    </div>-->
    <p>{{ response }}</p>
    <input v-model="guess" />
    <button v-on:click="checkGuess()">Enter</button>
  </div>
</template>

<style></style>