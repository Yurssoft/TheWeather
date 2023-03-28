# The Weather
## By [Yurii Boiko](https://www.linkedin.com/in/yurii-boiko/)

This project main intention to make modular application and expand tests for it. It is written in a way to support injected dependecies from preview and have mocks ready to use.

### Trade-Offs
    In order to finish this project in reasonable time, decisions made:
- not to posih search, sometimes it is stuck, it is possible to add debounce
- not to handle all possible location & requests errors
- did not create repository & location tests as this objects very straightforward
- simplify only important view model tests
- basic details, not polished. Main point is to use UIKit
- would be nice to have state with loading and error, this is what would I usually do
