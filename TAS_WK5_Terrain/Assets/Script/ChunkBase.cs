using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ChunkBase : MonoBehaviour
{
    public Material terrainMat;
    public float height = 1f;
    
    private MeshFilter myMF;
    private MeshRenderer myMR;
    private MeshCollider myMC;

    private Mesh myMesh;

    private Vector3[] verts;
    private int[] tris;
    private Vector2[] uVs;
    private Vector3[] normals;

    public int sizeSquare;
    private int totalVertInd;
    private int totalTrisInd;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            RenewChunk();
        }
    }

    private void Awake()
    {
        myMF = gameObject.AddComponent<MeshFilter>();
        myMR = gameObject.AddComponent<MeshRenderer>();
        myMC = gameObject.AddComponent<MeshCollider>();

        myMesh = new Mesh();
    }

    private void Start()
    {
        Init();
        RenewChunk();
    }

    private void Init()
    {
        totalVertInd = (sizeSquare + 1) * (sizeSquare + 1);
        totalTrisInd = (sizeSquare) * (sizeSquare) * 2 * 3;
        verts = new Vector3[totalVertInd];
        tris = new int[totalTrisInd];
        uVs = new Vector2[totalVertInd];
        normals = new Vector3[totalVertInd];
    }

    private void CalcMesh()
    {
        for (int z = 0; z <= sizeSquare; z++)
        {
            for (int x = 0; x <= sizeSquare; x++)
            {
                var v0 = new Vector3(x, 
                    height * Perlin.Noise(
                        ((float)x + transform.position.x) / 8, 
                        ((float)z + transform.position.z) / 8), 
                    z);
                var v1 = new Vector3(x + 1, 
                    height * Perlin.Noise(
                        ((float)(x + 1) + transform.position.x) / 8, 
                        ((float)z + transform.position.z) / 8), 
                    z);
                var v2 = new Vector3(x + 1, 
                    height * Perlin.Noise(
                        ((float)(x + 1) + transform.position.x) / 8, 
                        ((float)(z + 1) + transform.position.z) / 8), 
                    z + 1);
                var v3 = new Vector3(x - 1, 
                    height * Perlin.Noise(
                        ((float)(x - 1) + transform.position.x) / 8, 
                        ((float)(z + 1) + transform.position.z) / 8), 
                    z + 1);
                var v4 = new Vector3(x - 1, 
                    height * Perlin.Noise(
                        ((float)(x - 1) + transform.position.x) / 8, 
                        ((float)(z - 1) + transform.position.z) / 8), 
                    z - 1);

                var d1 = (v1 - v0).normalized;
                var d2 = (v2 - v0).normalized;
                var d3 = (v3 - v0).normalized;
                var d4 = (v4 - v0).normalized;

                //apply verts
                verts[(z * (sizeSquare + 1)) + x] = v0;
                //calculate average normals
                normals[(z * (sizeSquare + 1)) + x] =
                    -(Vector3.Cross(d1, d2) + Vector3.Cross(d2, d3) + Vector3.Cross(d3, d4) + Vector3.Cross(d4, d1))
                    .normalized;
                //apply UV
                uVs[(z * (sizeSquare + 1)) + x] = new Vector2((float)x/sizeSquare, (float)z/sizeSquare);
            }
        }

        int triInd = 0;

        for (int i = 0; i < sizeSquare; i++)
        {
            for (int j = 0; j < sizeSquare; j++)
            {
                int bottomLeft = j + (i * (sizeSquare + 1)); // true as long as j < sizesquare - 1
                int bottomRight = j + (i * (sizeSquare + 1)) + 1; // true as long as j < sizesquare -1
                int topLeft = j + ((i + 1) * (sizeSquare + 1));
                int topRight = j + ((i + 1) * (sizeSquare + 1)) + 1;

                tris[triInd] = bottomLeft;
                triInd++;
                tris[triInd] = topLeft;
                triInd++;
                tris[triInd] = bottomRight;
                triInd++;
                tris[triInd] = topLeft;
                triInd++;
                tris[triInd] = topRight;
                triInd++;
                tris[triInd] = bottomRight;
                triInd++;
            }
        }
    }

    private void ApplyMesh()
    {
        myMesh.vertices = verts;
        myMesh.triangles = tris;
        myMesh.uv = uVs;
        myMesh.normals = normals;

        myMF.mesh = myMesh;

        myMR.material = terrainMat;
        myMC.sharedMesh = myMF.mesh;
    }

    private void FixSeams()
    {
        
    }

    public void RenewChunk()
    {
        CalcMesh();
        ApplyMesh();
    }


}