# DescriptiveFunctor

This package implements a very simple compiler/interpreter based on a functor law.

The language that the compiler understands is very simple: All you can do is to chain arrows. Hence, the language is not Turing-Complete - not even primitive recusion is implemented. However, the compiler perfectly enables you to separate the chaining of "arrows" from actually giving those arrows meaning.

Use-cases to think about:

1. You may have a chain of API calls where the next call depends on the result of the current one, but actually you don't need any local information to make the next call, just the result of the current call. You may as well skip the network communication and do the whole computation at the backend. One way to approach that problem would be to talk to your colleagues working on the backend to create a special route for your use-case. Another approach would be to design the backend in a way to enable the frontend to chain API calls.

2. In signal processing, certain calculations can be done more efficiently on the FFT of a signal than on the signal itself. There are three possible ways to go now: The least effective would be to implement those calculations by calculating the FFT, doing the calculation and calculating the IFFT; as you chain functions that could be done on the Fourier transform, this becomes inefficient. A more effective way would be to implement those calculations on the Fourier transformed signal and calculating the FFT and IFFT once. However, that way you will always have to explicitly convert the signal in order to do your calculations. A more implicit way could be to create a formal alphabet of arrows that you can chain and that can be mapped to a single computation on the Fourier transform. This chained arrow may then be converted to a single arrow on the original signal.

Currently, the package is more of a proof of concept and it doesn't have inbuilt support for any of the above usecases. However, above considerations may give you an idea how somewhat generalized Functors could actually be useful in the real world.
