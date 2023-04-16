using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReadCube : MonoBehaviour
{
    // Transformačné objekty
    public Transform tUp;
    public Transform tDown;
    public Transform tLeft;
    public Transform tRight;
    public Transform tFront;
    public Transform tBack;

    // Zoznamy obsahujúce lúče snímajúce farbu kocky
    private List<GameObject> frontRays = new List<GameObject>();
    private List<GameObject> backRays = new List<GameObject>();
    private List<GameObject> upRays = new List<GameObject>();
    private List<GameObject> downRays = new List<GameObject>();
    private List<GameObject> leftRays = new List<GameObject>();
    private List<GameObject> rightRays = new List<GameObject>();

    // Layer Mask pre filtrovanie stien kocky
    private int layerMask = 1 << 8; // this layermask is for the faces of the cube only

    // Premenná ukladajúci stav kocky
    CubeState cubeState;

    // Premenná pre pomocné objekty
    public GameObject emptyGO;

    // Start metóda sa volá vždy na začiatku - ako setup metóda v Arduine
    void Start()
    {
        SetRayTransforms();

        cubeState = FindObjectOfType<CubeState>();
        ReadState();

        CubeState.started = true;
    }

    // Inicializácia Nastavovania lúčov smerom na jednotlivé strany kocky
    void SetRayTransforms()
    {
        upRays = BuildRays(tUp, new Vector3(90,90,0));
        downRays = BuildRays(tDown, new Vector3(270,90,0));
        leftRays = BuildRays(tLeft, new Vector3(0,180,0));
        rightRays = BuildRays(tRight, new Vector3(0,0,0));
        frontRays = BuildRays(tFront, new Vector3(0,90,0));
        backRays = BuildRays(tBack, new Vector3(0,270,0));
    }

    // Samotné nastavovanie lúčov - vytvorí 9 lúčov v nasledovnom poradí:
    //      0|1|2
    //      3|4|5
    //      6|7|8
    List<GameObject> BuildRays(Transform rayTransform, Vector3 direction)
    {
        // Využívaný na zistenie správneho poradia lúčov
        int rayCount = 0;

        List<GameObject> rays = new List<GameObject>();

        for (int y = 1; y > -2; y--)
        {
            for (int x = -1; x < 2; x++)
            {
                Vector3 startPos = new Vector3(rayTransform.localPosition.x + x,
                    rayTransform.localPosition.y + y,
                    rayTransform.localPosition.z
                );

                GameObject rayStart = Instantiate(emptyGO, startPos, Quaternion.identity, rayTransform);
                rayStart.name = rayCount.ToString();
                rays.Add(rayStart);
                rayCount++;
            }
        }
        rayTransform.localRotation = Quaternion.Euler(direction);
        return rays;
    }

    // Inicializuje čítanie stavu kocky 
    public void ReadState()
    {
        cubeState = FindObjectOfType<CubeState>();

        cubeState.up = ReadFace(upRays, tUp);
        cubeState.down = ReadFace(downRays, tDown);
        cubeState.left = ReadFace(leftRays, tLeft);
        cubeState.right = ReadFace(rightRays, tRight);
        cubeState.front = ReadFace(frontRays, tFront);
        cubeState.back = ReadFace(backRays, tBack);
    }

     // Funkcia čítajúca farbu steny kocky
    public List<GameObject> ReadFace(List<GameObject> rayStarts, Transform rayTransform)
    {
        List<GameObject> facesHit = new List<GameObject>();

        foreach (GameObject rayStart in rayStarts)
        {
            Vector3 ray = rayStart.transform.position;
            RaycastHit hit;

            // Pretína lúč v maske nejaké objekty?
            if (Physics.Raycast(ray, rayTransform.forward, out hit, Mathf.Infinity, layerMask))
            {
                Debug.DrawRay(ray, rayTransform.forward * hit.distance, Color.yellow);
                facesHit.Add(hit.collider.gameObject);
            }
            else
            {
                Debug.DrawRay(ray, rayTransform.forward * 1000, Color.green);
            }
        }

        return facesHit;
    }
}
