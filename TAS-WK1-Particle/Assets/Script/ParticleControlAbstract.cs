using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleControlAbstract : MonoBehaviour {

    GameObject tornadoPivot;
    GameObject tornado;
    ParticleSystem tornadoRing1;   
    ParticleSystem tornadoCore1;
    ParticleSystem tornadoCore2;

    GameObject leaf;

    float topSize = 1.0f;
    float middleSize = 0.3f;
    float bottomSize = 0.13f;

    // Use this for initialization
    void Start () {
        tornadoPivot = GameObject.Find("TornadoPivot");
        tornado = tornadoPivot.transform.Find("Tornado").gameObject;
        tornadoRing1 = tornado.transform.Find("TornadoRing1").GetComponent<ParticleSystem>();
        tornadoCore1 = tornado.transform.Find("TornadoCore1").GetComponent<ParticleSystem>();
        tornadoCore2 = tornado.transform.Find("TornadoCore2").GetComponent<ParticleSystem>();

        leaf = tornado.transform.Find("Leaf").gameObject;
    }
	
	// Update is called once per frame
	void Update () {
		
	}

    public void ChangeRotationSpeed (float val)
    {
        leaf.GetComponent<SelfRotation>().speedY = val * 200;
    }

    public void ChangeCoreSize (float val)
    {
        var _main = tornadoCore1.main;
        _main.startSize = val * 40f;

        var _em = tornadoCore1.emission;
        _em.rateOverTime = val * 4f;
    }

    public void ChangeRingMoveSpeed(float val)
    {
        var _main = tornadoRing1.main;
        _main.startLifetime = 2.5f/val;
        _main.startSpeed = 80f * val;

        var _em = tornadoRing1.emission;
        _em.rateOverTime = val * 10f;

    }

}
