using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeTreadmill : MonoBehaviour
{
    public GameObject cube;

    public GameObject target;

    [HideInInspector]
    public int size = 10;

    private List<GameObject> cubes;

    private Vector3 intPos;
    private Vector3 currentIntPos;
    private Vector3 oldIntPos;

    private TerrainControl terrainControl;

    void Start()
    {
        terrainControl = GameObject.Find("TerrainControl").GetComponent<TerrainControl>();
        
        cubes = new List<GameObject>();

        for (int i = 0; i < 2; i++)
        {
            for (int j = 0; j < 2; j++)
            {
                cubes.Add(Instantiate(cube, new Vector3(j * size, 0, i * size) + new Vector3(target.transform.position.x - size/2f, 0, target.transform.position.z - size/2f), Quaternion.identity));
            }
        }
        
        oldIntPos = new Vector3(Mathf.Floor(target.transform.position.x / size) , 0, Mathf.Floor(target.transform.position.z / size));
    }

    void Update()
    {
        intPos = new Vector3(Mathf.Floor(target.transform.position.x / size) , 0, Mathf.Floor(target.transform.position.z / size));

        if (intPos != oldIntPos)
        {
            if (intPos.x > oldIntPos.x)
            {
                foreach(GameObject g in cubes)
                {
                    g.transform.position += Vector3.right * size;
                }
                terrainControl.RenewTerrainX(true);
            }
            if (intPos.x < oldIntPos.x)
            {
                foreach(GameObject g in cubes)
                {
                    g.transform.position -= Vector3.right * size;
                }
                terrainControl.RenewTerrainX(false);
            }
            if (intPos.z > oldIntPos.z)
            {
                foreach (GameObject g in cubes)
                {
                    g.transform.position += Vector3.forward * size;
                }
                terrainControl.RenewTerrainZ(true);
            }
            if (intPos.z < oldIntPos.z)
            {
                foreach (GameObject g in cubes)
                {
                    g.transform.position -= Vector3.forward * size;
                }
                terrainControl.RenewTerrainZ(false);
            }

            oldIntPos = intPos;
        }
    }
}