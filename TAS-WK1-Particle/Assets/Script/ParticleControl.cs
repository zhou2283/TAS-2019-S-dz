using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleControl : MonoBehaviour {

    GameObject tornadoPivot;
    GameObject tornado;
    ParticleSystem tornadoRing1;
    ParticleSystem tornadoRing2;
    ParticleSystem tornadoCore1;

    float topSize = 1.0f;
    float middleSize = 0.3f;
    float bottomSize = 0.13f;

    // Use this for initialization
    void Start () {
        tornadoPivot = GameObject.Find("TornadoPivot");
        tornado = tornadoPivot.transform.Find("Tornado").gameObject;
        tornadoRing1 = tornado.transform.Find("TornadoRing1").GetComponent<ParticleSystem>();
        tornadoRing2 = tornado.transform.Find("TornadoRing2").GetComponent<ParticleSystem>();
        tornadoCore1 = tornado.transform.Find("TornadoCore1").GetComponent<ParticleSystem>();

    }
	
	// Update is called once per frame
	void Update () {
		
	}

    public void ChangeRotationSpeed (float val)
    {
        tornadoPivot.GetComponent<SelfRotation>().speedY = val * 100;
    }

    public void ChangeStrenthTop (float val)
    {
        
        AnimationCurve curve = new AnimationCurve();
        topSize = val;
        curve.AddKey(0.0f, bottomSize);
        curve.AddKey(0.5f, middleSize);
        curve.AddKey(1.0f, topSize);

        var _sol = tornadoRing1.sizeOverLifetime;
        _sol.size = new ParticleSystem.MinMaxCurve(4f, curve);
        _sol = tornadoRing2.sizeOverLifetime;
        _sol.size = new ParticleSystem.MinMaxCurve(4f, curve);
        _sol = tornadoCore1.sizeOverLifetime;
        _sol.size = new ParticleSystem.MinMaxCurve(4f, curve);
    }

    public void ChangeStrenthMiddle(float val)
    {
        
        AnimationCurve curve = new AnimationCurve();
        middleSize = val;
        curve.AddKey(0.0f, bottomSize);
        curve.AddKey(0.5f, middleSize);
        curve.AddKey(1.0f, topSize);

        var _sol = tornadoRing1.sizeOverLifetime;
        _sol.size = new ParticleSystem.MinMaxCurve(4f, curve);
        _sol = tornadoRing2.sizeOverLifetime;
        _sol.size = new ParticleSystem.MinMaxCurve(4f, curve);
        _sol = tornadoCore1.sizeOverLifetime;
        _sol.size = new ParticleSystem.MinMaxCurve(4f, curve);

    }

    public void ChangeStrenthBottom(float val)
    {
        
        AnimationCurve curve = new AnimationCurve();
        bottomSize = val;
        curve.AddKey(0.0f, bottomSize);
        curve.AddKey(0.5f, middleSize);
        curve.AddKey(1.0f, topSize);

        var _sol = tornadoRing1.sizeOverLifetime;
        _sol.size = new ParticleSystem.MinMaxCurve(4f, curve);
        _sol = tornadoRing2.sizeOverLifetime;
        _sol.size = new ParticleSystem.MinMaxCurve(4f, curve);
        _sol = tornadoCore1.sizeOverLifetime;
        _sol.size = new ParticleSystem.MinMaxCurve(4f, curve);

    }
}
