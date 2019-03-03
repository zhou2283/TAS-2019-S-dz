using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TerrainControl : MonoBehaviour
{
    public GameObject chunkBase;
    public GameObject player;
    public CubeTreadmill cubeTreadmill;

    public int size = 3;
    public int chunkSize = 10;
    private GameObject[,] chunkArray;
    public int centerX = 1;
    public int centerZ = 1;
    // Start is called before the first frame update
    void Start()
    {
        InitializeTerrain();
        SetPlayer();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void InitializeTerrain()
    {
        if (size % 2 == 0)
        {
            size++;//make sure size is odd
        }

        centerX = centerZ = size / 2;
        
        
        chunkArray = new GameObject[size, size];
        for (int z = 0; z < size; z++)
        {
            for (int x = 0; x < size; x++)
            {
                chunkArray[x, z] = Instantiate(chunkBase, new Vector3(x * chunkSize, 0, z * chunkSize),
                    Quaternion.identity);
                chunkArray[x, z].GetComponent<ChunkBase>().sizeSquare = chunkSize;
                chunkArray[x, z].GetComponent<ChunkBase>().enabled = true;
            }
        }
    }

    public void SetPlayer()
    {
        var xz = (new Vector2(centerX, centerZ) + Vector2.one * 0.5f) * chunkSize;
        player.transform.position = new Vector3(xz.x,3,xz.y);
        cubeTreadmill.size = chunkSize;
        cubeTreadmill.enabled = true;
    }

    public void RenewTerrainX(bool isForward)
    {
        if (isForward)
        {
            int renewIndex = FindBackIndex(centerX);
            centerX = AddOneInSize(centerX);
            for (int i = 0; i < size; i++)
            {
                chunkArray[renewIndex, i].transform.position +=  Vector3.right * chunkSize * size;
                chunkArray[renewIndex, i].GetComponent<ChunkBase>().RenewChunk();
            }
        }
        else
        {
            int renewIndex = FindFrontIndex(centerX);
            centerX = MinusOneInSize(centerX);
            for (int i = 0; i < size; i++)
            {
                chunkArray[renewIndex, i].transform.position -=  Vector3.right * chunkSize * size;
                chunkArray[renewIndex, i].GetComponent<ChunkBase>().RenewChunk();
            }
        }
    }
    
    public void RenewTerrainZ(bool isForward)
    {
        if (isForward)
        {
            int renewIndex = FindBackIndex(centerZ);
            centerZ = AddOneInSize(centerZ);
            for (int i = 0; i < size; i++)
            {
                chunkArray[i, renewIndex].transform.position +=  Vector3.forward * chunkSize * size;
                chunkArray[i, renewIndex].GetComponent<ChunkBase>().RenewChunk();
            }
        }
        else
        {
            int renewIndex = FindFrontIndex(centerZ);
            centerZ = MinusOneInSize(centerZ);
            for (int i = 0; i < size; i++)
            {
                chunkArray[i, renewIndex].transform.position -=  Vector3.forward * chunkSize * size;
                chunkArray[i, renewIndex].GetComponent<ChunkBase>().RenewChunk();
            }
        }
    }

    int AddOneInSize(int num)
    {
        return (num + 1) % size;
    }
    
    int MinusOneInSize(int num)
    {
        return (num + size - 1) % size;
    }
    
    int FindFrontIndex(int center)
    {
        return (center + size/2) % size;
    }
    
    int FindBackIndex(int center)
    {
        return (center + size/2 + 1) % size;
    }
}
