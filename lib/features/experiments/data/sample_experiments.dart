// Sample experiments data - Easy to modify and add more
import 'package:tokenx/features/experiments/models/experiment_model.dart';

final sampleExperiments = [
  ExperimentModel(
    id: 'exp_001',
    title: 'MNIST Digit Recognition',
    description:
        'A classic deep learning experiment using convolutional neural networks to classify handwritten digits from the MNIST dataset. Includes data preprocessing, model training, and evaluation.',
    author: 'Priyansh Shakya',
    tags: ['Deep Learning', 'CNN', 'Classification'],
    difficulty: 'Beginner',
    concepts: 'Neural Networks, Convolution, Backpropagation',
    githubLink:
        'https://github.com/Priyansh-Shakya/AIML-experiments-learning/blob/main/experiments/mnist.ipynb',
    notebookName: 'mnist.ipynb',
    createdAt: DateTime(2025, 8, 15),
  ),
  ExperimentModel(
    id: 'exp_002',
    title: 'Transformer Architecture from Scratch',
    description:
        'Building a transformer architecture from first principles. Covers self-attention mechanism, multi-head attention, positional encoding, and the complete encoder-decoder stack implementation.',
    author: 'Priyansh Shakya',
    tags: ['NLP', 'Transformers', 'LLM'],
    difficulty: 'Advanced',
    concepts: 'Self-Attention, Positional Encoding, Multi-head Attention',
    githubLink:
        'https://github.com/Priyansh-Shakya/AIML-experiments-learning/blob/main/experiments/Transformer.ipynb',
    notebookName: 'transformer.ipynb',
    createdAt: DateTime(2025, 9, 20),
  ),
  ExperimentModel(
    id: 'exp_003',
    title: 'RAG System Implementation',
    description:
        'Retrieval-Augmented Generation system combining vector databases with LLMs. Features document chunking, embedding generation, semantic search, and response synthesis.',
    author: 'Priyansh Shakya',
    tags: ['LLM', 'RAG', 'Vector DB'],
    difficulty: 'Intermediate',
    concepts: 'Vector Embeddings, Semantic Search, Prompt Engineering',
    githubLink:
        'https://github.com/Priyansh-Shakya/AIML-experiments-learning/blob/main/experiments/rag.ipynb',
    notebookName: 'rag.ipynb',
    createdAt: DateTime(2025, 10, 5),
  ),
];
