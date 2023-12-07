Advent of Code - Day 1

I know I'm late on this now shush.
It's that time of the year again! Advent of code is here for 2023, and I plan on making a post
for every single day. I am learning C still, so I figured AOC would be a great way to learn more
about the language.

---

## What is Advent of Code?
For the uninformed, [Advent of Code](https://adventofcode.com) is a yearly event where from December 1st to December 25th
a coding challenge is posted for you to solve, typically in two parts. 
Therefore, it acts as a programmers advent calendar with 25 fun coding problems for us to cry over, how fun!
## Onto the problem...
### Part 1
[Day 1](https://adventofcode.com/2023/day/1) asks us to take a string on each line of a file and form a single
two-digit number using the first and last number in the string. We then need to add up all these numbers to get our solution.
In their example, we are given

    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet

So we would get the numbers `12`, `38`, `15`, and `77`. After adding them we get the solution `142`.
#### My approach
String parsing... in C... what fun.
Anyway, the first thing I needed to figure out was how I planned on getting the first and last numbers.
Looking through the C standard library, I found `strcspn`, which essentially returns the index of the first
character in a string that is in a list of characters. So by calling `strcspn(line, "0123456789");` I could get
the index of the first number. 
Finding the index of the *last* number proved to take a couple extra steps, however. I figured to keep it simple,
I would stick with using `strcspn` but after reversing the string. I found a [really simple algorithm](https://code.whatever.social/questions/784417/reversing-a-string-in-c#784442) to reverse a string in C, so I decided to move forward with that.

    // Simple function to reverse a string
    void reverse(char *str) {
        size_t len = strlen(str);
        for (size_t i = 0, k = len - 1; i < (len / 2); i++, k--) {
            char temp = str[k];
            str[k] = str[i];
            str[i] = temp;
        }
    }

Once the string was reversed, I could fetch the last number by just calling `strcspn` on the reversed string.
Finally, I can add to the result by multiplying the first number by ten and adding it to the second number.
Run the code on `input.txt`, print the result and... **boom!** part 1 was solved!
#### Refactoring
Initially, I was making a copy of `line` and storing it in a second string and waiting until the end of the 
main loop to calculate the numbers. I realized I could bypass this by simply calculating the first number *and then*
reversing `line`. Since I already had the tens place stored, I didn't need to worry about the first number at all anymore.
I could simply call `strcspn` and forget about it. For readability sake, I decided to store `tens` and `ones` as their
own variables, instead of just iterating `result` after each calculation.
### Part 2
To add to the challenge, they ask us to also treat the actual *words* as numbers as well. That being,
`one`, `two`, `three`, etc. This was a bit of a problem because it meant I could no longer rely on one algorithm
for my entire solution. It was time to think a little more about the problem.
#### My approach
I figured I should still use `strcspn` to save the indexes of the first and last numbers, so I could later compare
those indexes with the first and last instances of one of the words. 

    size_t firstidx = strcspn(line, "0123456789");
    reverse(line);
    size_t lastidx = strlen(line) - strcspn(line, "0123456789") - 1;
    reverse(line);

But what if there *isn't* an actual number? Well, `strcspn` will just set the result to the length of the string so
we have no problems for `firstidx` since the indexes only get smaller from there. But to make sure we can also
check for the last index, I decided to set `lastidx` to `0` if `firstidx` is the length of the array.
Since we need to check for better options with the words later, we need to store the current `tens` and `ones`
immediately after getting `firstidx` and `lastidx` so that if we don't find any words, they are already set.
Now onto actually *finding* those words...
First, we need to iterate over each of the valid words (`one`, `two`, `three`...) and check for each one.
To actually check for them, I needed to find a way to look for a string inside of a string.
And once again, after searching through the C standard library, I found a nice little function called `strstr`,
which looks for a string inside of another string and returns its index. This is perfect! 
`strstr` makes it easy to find the first instance of a string, but what about the last?
I decided that what I could do was make a small loop that constantly looks for the requested word inside of the string,
and then if there is another instance of that word, cut everything before and including the word out of the string.

    while (strstr(lastword + strlen(words[i]), words[i])) {
        lastword = strstr(lastword + strlen(words[i]), words[i]);
    }

And once that while loop fails, we can move on to grabbing the indexes.

    if (firstidx > (size_t)(firstword - line)) {
        firstidx = firstword - line;
        tens = i + 1;
    }
    if (lastidx <= (size_t)(lastword - line)) {
        lastidx = lastword - line;
        ones = i + 1;
    }

Now here is when I realized I had been ignoring something *very important* for a while now.
What if that word isn't in the line?
It seems simple but I had completely overlooked it!
To fix this, I added a simple check at the top of the loop.

    char *firstword = strstr(line, words[i]);
    char *lastword = strstr(line, words[i]);
    if (!firstword) {
        continue;
    }

Now all that is left is to add to the result and... once again, we have a solution!
#### Refactoring
I once again got rid of the redundant `reversed` string and simply reversed `line` after getting the last index of a number.
Other than that, I struggle to see anything else that could be massively improved.
## What have I learned?
Just on day 1, I managed to learn 2 C functions I didn't know existed, and I learned quite a bit about string manipulation
in C in general. I struggled at times from trying to oversimplify my solution when what I had worked just fine, and part 2
really threw me for a whirl when I first got around to thinking about it.
## Resources
- [My code](https://github.com/gaffclant/adventofcode-2023/tree/main/day1/C)
- [Reverse a string in C](https://code.whatever.social/questions/784417/reversing-a-string-in-c#784442)
- [Glibc string search functions](https://sourceware.org/glibc/manual/html_node/Search-Functions.html)
## Thank you!
Really, Thank you for taking the time to read! Please consider sharing if you feel like this helped you at all,
and feel free to message me on [matrix](https://matrix.to/#/@gaffclnt:matrix.org) or [email me](mailto:gaffclant@gaffclant.dev)
with any comments or suggestions on how I can improve my writing style, my code, or both.

Tags: advent-of-code, C, programming, strings
