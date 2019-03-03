﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestMove : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.W))
        {
            transform.Translate(new Vector3(0,0,5*Time.deltaTime));
        }
        if (Input.GetKey(KeyCode.S))
        {
            transform.Translate(-new Vector3(0,0,5*Time.deltaTime));
        }
        if (Input.GetKey(KeyCode.A))
        {
            transform.Rotate(new Vector3(0,-15*Time.deltaTime,0));
        }
        if (Input.GetKey(KeyCode.D))
        {
            transform.Rotate(new Vector3(0,15*Time.deltaTime,0));
        }
    }
}
