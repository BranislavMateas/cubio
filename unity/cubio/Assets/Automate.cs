using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FlutterUnityIntegration;
using System.Linq;
using Kociemba;

public class Automate : MonoBehaviour
{
    private UnityMessageManager Manager
    {
        get { return GetComponent<UnityMessageManager>(); }
    }

    public static List<string> moveList = new List<string>() { };

    private readonly List<string> allMoves = new List<string>()
    {
        "U", "D", "L", "R", "F", "B",
        "U2", "D2", "L2", "R2", "F2", "B2",
        "U'", "D'", "L'", "R'", "F'", "B'",
        "U2'", "D2'", "L2'", "R2'", "F2'", "B2'",
    };

    private CubeState cubeState;
    private ReadCube readCube;

    float countdownLength = CubeState.isInit ? 0.1f : 0.5f;
    float solveCountdown = 1f;

    // The elapsed time, in seconds
    float secondsElapsed = 0f;
    float secondsWithoutMove = 0f;

    void Start()
    {
        cubeState = FindObjectOfType<CubeState>();
        readCube = FindObjectOfType<ReadCube>();

        Solve();
    }

    void Update()
    {
        secondsElapsed += Time.deltaTime;
            secondsWithoutMove += Time.deltaTime;

        if (moveList.Count > 0 && CubeState.started && secondsElapsed >= countdownLength) {
            secondsWithoutMove = 0f;
            DoMove(moveList[0]);
        
        }
    }

    void LateUpdate() {
        if (secondsWithoutMove >= solveCountdown && CubeState.doSolve) {
            Solve();
        }
    }

    public void SetupPosition(string cubeStringState)
    {
        CubeState.isInit = true;
        string info = "";
        string solution = Search.solution(cubeStringState, out info);
        List<string> solutionList = StringToList(solution);
        moveList = ReverseMoves(solutionList);
    }

    public List<string> OptimizeSolution(string solution)
    {
        List<string> optimizedMoves = new List<string>();

        foreach (string move in solution.Split(' '))
        {
            int moveCount = 1;
            bool isPrime = false;
            string currentMove = move;
            if (currentMove.EndsWith("'"))
            {
                isPrime = true;
                currentMove = currentMove.Substring(0, currentMove.Length - 1);
            }
            if (currentMove.EndsWith("2"))
            {
                string moveWithoutTwo = currentMove.Substring(0, currentMove.Length - 1);
                moveCount = 2;
                for (int i = 0; i < moveCount; i++)
                {
                    optimizedMoves.Add(isPrime ? moveWithoutTwo + "'" : moveWithoutTwo);
                }
            }
            else
            {
                optimizedMoves.Add(isPrime ? currentMove + "'" : currentMove);
            }
        }

        return optimizedMoves;
    }

    private void Solve()
    {   
        CubeState.doSolve = false;

        readCube.ReadState();

        string moveString = cubeState.GetStateString();

        string info = "";
        string solution = Search.solution(moveString, out info);

        string optimizedSolution = string.Join(" ", OptimizeSolution(solution));
        
        Manager.SendMessageToFlutter(optimizedSolution);

        secondsWithoutMove = 0f;
    }

    List<string> ReverseMoves(List<string> originalMoves)
    {
        List<string> result = new List<string>();

        foreach(string move in originalMoves)
        {
            int index = allMoves.IndexOf(move);

            if (index >= 0 && index <= 5 || index >= 6 && index <= 11)
            {
                result.Add(allMoves[index + 12]);
            }
            else if (index >= 12 && index <= 17 || index >= 18 && index <= 23)
            {
                result.Add(allMoves[index - 12]);
            }
        }

        result.Reverse();
        return result;
    }

    public List<string> StringToList(string solution)
    {
        List<string> solutionList = new List<string>(solution.Split(new string[] { " " }, System.StringSplitOptions.RemoveEmptyEntries));
        return solutionList;
    }

    public void MyMove(string move) {
        CubeState.isInit = false;
        moveList.Add(move);
    }

    void DoMove(string nextMove)
    {
        readCube.ReadState();

        if (CubeState.started)
        {
            if (nextMove == "U")
            {
                RotateSide(cubeState.up, -90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "U'")
            {
                RotateSide(cubeState.up, 90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "U2")
            {
                RotateSide(cubeState.up, -180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "U2'")
            {
                RotateSide(cubeState.up, 180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "D")
            {
                RotateSide(cubeState.down, -90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "D'")
            {
                RotateSide(cubeState.down, 90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "D2")
            {
                RotateSide(cubeState.down, -180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "D2'")
            {
                RotateSide(cubeState.down, 180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "L")
            {
                RotateSide(cubeState.left, -90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "L'")
            {
                RotateSide(cubeState.left, 90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "L2")
            {
                RotateSide(cubeState.left, -180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "L2'")
            {
                RotateSide(cubeState.left, 180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "R")
            {
                RotateSide(cubeState.right, -90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "R'")
            {
                RotateSide(cubeState.right, 90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "R2")
            {
                RotateSide(cubeState.right, -180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "R2'")
            {
                RotateSide(cubeState.right, 180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "F")
            {
                RotateSide(cubeState.front, -90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "F'")
            {
                RotateSide(cubeState.front, 90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "F2")
            {
                RotateSide(cubeState.front, -180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "F2'")
            {
                RotateSide(cubeState.front, 180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "B")
            {
                RotateSide(cubeState.back, -90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "B'")
            {
                RotateSide(cubeState.back, 90);
                countdownLength = CubeState.isInit ? 0.05f : 0.25f;
            }
            if (nextMove == "B2")
            {
                RotateSide(cubeState.back, -180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }
            if (nextMove == "B2'")
            {
                RotateSide(cubeState.back, 180);
                countdownLength = CubeState.isInit ? 0.1f : 0.5f;
            }

            moveList.Remove(moveList[0]);
            CubeState.doSolve = true;

            secondsElapsed = 0f;
        }
    }

    void RotateSide(List<GameObject> side, float angle)
    {
        PivotRotation pr = side[4].transform.parent.GetComponent<PivotRotation>();
        pr.StartAutoRotate(side, angle);
    }
}
