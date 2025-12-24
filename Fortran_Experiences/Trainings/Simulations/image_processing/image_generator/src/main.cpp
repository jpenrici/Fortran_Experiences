/**
 * File: main.cpp
 * Description: High-performance Fractal generator.
 * Result: Binary PPM image (P6).
 * Reference: https://en.wikipedia.org/wiki/Mandelbrot_set
 */

#include <algorithm>
#include <complex>
#include <fstream>
#include <print>
#include <string>
#include <string_view>
#include <thread>
#include <vector>

// Terminal colors : Output formatting
namespace Color {
constexpr std::string_view RED = "\033[0;31m";
constexpr std::string_view GREEN = "\033[0;32m";
// constexpr std::string_view YELLOW = "\033[1;33m";
constexpr std::string_view CYAN = "\033[0;36m";
constexpr std::string_view NC = "\033[0m"; // No Color
} // namespace Color

// Simulation constants
constexpr int WIDTH = 3840;
constexpr int HEIGHT = 2160;
constexpr int MAX_ITER = 255;

/**
 * Fractal calculation (Mandelbrot Set)
 * Renders a specific range of rows in the fractal image.
 */
void render_chunk(int start_y, int end_y, std::vector<unsigned char> &buffer) {
  for (int y = start_y; y < end_y; ++y) {
    for (int x = 0; x < WIDTH; ++x) {
      // Map pixel coordinates to the complex plane
      float pr = 1.5f * (x - WIDTH / 2.0f) / (0.5f * WIDTH);
      float pi = (y - HEIGHT / 2.0f) / (0.5f * HEIGHT);

      std::complex<float> c(pr, pi);
      std::complex<float> z(0, 0);

      int iter = 0;
      while (std::norm(z) <= 4.0f && iter < MAX_ITER) {
        z = z * z + c;
        iter++;
      }

      int index = (y * WIDTH + x) * 3;
      buffer[index] = static_cast<unsigned char>(iter % 256);
      buffer[index + 1] = static_cast<unsigned char>((iter * 5) % 256);
      buffer[index + 2] = static_cast<unsigned char>((iter * 10) % 256);
    }
  }
}

auto main(int argc, char *argv[]) -> int {
  // 1. Argument validation
  if (argc < 2) {
    std::println(stderr, "{}Usage: {} <output_path.ppm>{}", Color::RED, argv[0],
                 Color::NC);
    return 1;
  }

  const std::string outputPath = argv[1];

  // 2. Determine CPU Core usage
  unsigned int total_cores = std::thread::hardware_concurrency();
  unsigned int num_threads = std::max(1u, total_cores / 2); // % 50 of cores

  std::println("{}>>> CPU Cores detected: {}. Using {} threads (50%)...{}",
               Color::CYAN, total_cores, num_threads, Color::NC);

  // 3. Prepare Buffer
  std::vector<unsigned char> buffer(WIDTH * HEIGHT * 3);
  std::vector<std::jthread> workers;

  // 4. Dispatch Parallel Tasks
  int rows_per_thread = HEIGHT / num_threads;

  for (unsigned int i = 0; i < num_threads; ++i) {
    int start_y = i * rows_per_thread;
    // Ensure the last thread covers any remaining rows due to division rounding
    int end_y = (i == num_threads - 1) ? HEIGHT : start_y + rows_per_thread;

    // Using jthread (C++20) for automatic joining
    workers.emplace_back(render_chunk, start_y, end_y, std::ref(buffer));
  }

  // Threads join automatically when workers vector goes out of scope or is
  // cleared, but we'll wait for them here implicitly as they finish their task.
  workers.clear();

  // 5. Bulk Write to File
  std::ofstream outFile(outputPath, std::ios::binary);
  if (!outFile) {
    std::println(stderr, "{}Error: File access denied.{}", Color::RED,
                 Color::NC);
    return 1;
  }

  std::print(outFile, "P6\n{} {}\n255\n", WIDTH, HEIGHT);
  outFile.write(reinterpret_cast<const char *>(buffer.data()), buffer.size());

  std::println("{}>>> Image rendered and saved with {} threads!{}",
               Color::GREEN, num_threads, Color::NC);

  return 0;
}
