
## The Library Analogy

Imagine you walk into a massive library and ask the librarian:

**"Find me something related to space exploration."**

The librarian does three things:

1. She writes down what you're looking for on a card — **"space exploration"** → this is your **Query**
2. She looks at the _index labels_ on every shelf — **"Astronomy", "Physics", "NASA History", "Sci-Fi"** → these are the **Keys**
3. She pulls out the _actual books_ from the shelves that match — the books themselves → these are the **Values**

That's it. That's Q, K, V.

- **Query** = _"What am I looking for?"_
- **Key** = _"What does each thing claim to be about?"_
- **Value** = _"What does each thing actually contain?"_

---

The one-line memory anchor: **Query asks. Key labels. Value delivers.**

The subtle thing that trips most people up is the Key/Value split. Why have two separate vectors for each token instead of one? Because _knowing something is relevant_ and _using what it contains_ are two different operations. A token can have a distinctive, recognizable label (strong Key) but contribute a small, subtle piece of meaning (quiet Value). Separating them gives the model much more flexibility in how it routes information.
