# Notes

- I've focused on the model rather than the view and controller as I believe the spirit of the exercise was to illustrate architectural design and approach to testing.
- I've only coded for the happy path within the (e.g. if the network is down then there is no 'retry' button) but there are tests for failure cases.
- I've avoided using any dependancies. If the app was more complex I would probably use something to aid the JSON parsing.
- I didn't write the tests first. This is because the app architecture is one I have created countless times before and it would be artificial for me to write tests. The test coverage for the model is almost 100%.
