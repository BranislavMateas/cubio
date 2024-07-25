using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PivotRotation : MonoBehaviour
{
    private List<GameObject> activeSide;
    private float speed = 300f;

    private Quaternion targetQuaternion;

    private ReadCube readCube;
    private CubeState cubeState;

    private bool autorotating = false;

    void Start()
    {
        readCube = FindObjectOfType<ReadCube>();
        cubeState = FindObjectOfType<CubeState>();
    }

    void Update()
    {
        if (CubeState.started && autorotating)
        {
            AutoRotate();
        }
    }

    public void StartAutoRotate(List<GameObject> side, float angle)
    {
       cubeState.PickUp(side);
        Vector3 localForward = Vector3.zero - side[4].transform.parent.transform.localPosition;
        targetQuaternion = Quaternion.AngleAxis(angle, localForward) * transform.localRotation;
        activeSide = side;
        autorotating = true;
    }

    private void AutoRotate()
    {
        if (CubeState.isInit)
        {
            transform.localRotation = targetQuaternion;

            cubeState.PutDown(activeSide, transform.parent);

            readCube.ReadState();
            autorotating = false;
        }
        else {
            var step = speed * Time.deltaTime * 2;
            transform.localRotation = Quaternion.RotateTowards(transform.localRotation, targetQuaternion, step);

            if (Quaternion.Angle(transform.localRotation, targetQuaternion) <= 1)
            {
                transform.localRotation = targetQuaternion;

                cubeState.PutDown(activeSide, transform.parent);

                readCube.ReadState();
                autorotating = false;
            }
        }
    }
}
