# Cubio

Cubio is a comprehensive project developed as my final Maturita project. It provides an interactive platform that communicates with the smart Rubik's Cube, specifically the Giiker Super Cube i3S model. The application is built using Flutter, while the 3D model of the cube is created in Unity.

## Getting Started

### Prerequisites

To run Cubio, you can either:

- Download an .apk release
- Run it by thyself

If the latter applies, ensure you have downloaded:
- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Unity: [Download and Install Unity](https://unity.com/)

### Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/yourusername/cubio.git
    cd cubio
    ```

2. **Set up the Flutter project:**
    ```sh
    flutter pub get
    ```

3. **Set up the Unity project:**
    - Follow the [flutter_unity_widget](https://pub.dev/packages/flutter_unity_widget) tutorial to integrate Unity with the Flutter application.

4. **Run the application**

## Usage

1. Ensure your Cube is charged and ready to pair.
2. Open the Cubio Flutter application.
3. Pair the application with your Cube via Bluetooth.
4. Start interacting with the cube and see real-time updates on the 3D model.

## Documentation

For a detailed explanation of the project's design, development process, and technical details, refer to the following resources:

- [Project Report (Slovak)](Maturitna_praca_Mateas.pdf)
- [Medium Article](TO)

## Contributing

Contributions are welcome! Please fork this repository and submit pull requests with your improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Note

- Note that models can be extended to your liking, however, communication may vary and will therefore need to be implemented.
- Unity export will probably fail on Ubuntu, use MacOS or Windows instead
- The project report might be slightly outdated
## Acknowledgments

- Special thanks to the creators of Flutter and Unity for their powerful and versatile tools.
- Thanks to the Giiker team for their innovative smart cube.
- Shoutout to Megalomobilezo for the inspiring video series: [Let's Make & Solve a Rubik's Cube in Unity](https://www.youtube.com/watch?v=JN9vx0veZ-c&list=PLuq_iMEtykn-ZOJyx2cY_k9WkixAhv11n).
- Thanks to Juanan Claramunt for the insightful article on the Xiaomi Mi Smart Rubik's Cube: [Medium Article](https://medium.com/@juananclaramunt/xiaomi-mi-smart-rubik-cube-ff5a22549f90).

## TODO

- Add purely virtual regime

---

Feel free to reach out for any questions or support!

---

## Happy Cubing!
