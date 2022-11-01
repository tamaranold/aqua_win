# aqua_win

As an avid board gamer, I love planning and deliberating moves. But counting points at the end is less fun. With the auqa projects I want to automate this part for the [Aqualin](https://boardgamegeek.com/boardgame/295948/aqualin) game.

In Auqalin, two players place colorful underwater animals on a common game board to end up with the largest swarms. There are 36 tokens, six animals in six different colors. One player is trying to place the same animals next to each other, the other is making groups in the same color. At the end, someone has to count the swarm sizes. And this is where this project begins. 

In the **auqa_model** project, image recognition models are trained to classify each token on the board by color and animal. In the **aqua_win** project, these algorithms are used inside an app to calculate the scores and determine the winner. 
