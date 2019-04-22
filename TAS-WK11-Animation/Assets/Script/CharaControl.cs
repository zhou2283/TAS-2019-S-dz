using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharaControl : MonoBehaviour
{
    private float walkRun_TreeVal_X;
    private float walkRun_TreeVal_Y;

    private float time;

    private float idleTime;

    private Animator _myAnimator;

    [Header("Tuning Values")]
    [Range(0.001f, 10.0f)] public float walkCycleTime;
    [Range(0.00f, 1.00f)] public float walkRunMagnitude;

    [Range(0.00f, 1.00f)] public float walkRunBlendTotal;
    // Start is called before the first frame update
    void Start()
    {
        _myAnimator = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.Space))
            _myAnimator.SetBool("IsIdle", true);
        else
            _myAnimator.SetBool("IsIdle", false);

        idleTime += Time.deltaTime * 6;
        _myAnimator.SetFloat("BlendIdle", (Mathf.Sin(idleTime)+1)/2);


        walkCycleTime = 1 - (.5f * walkRunBlendTotal);
        walkRunMagnitude = .25f + (.75f * walkRunBlendTotal);

        time += (Mathf.PI * 2 * Time.deltaTime) / walkCycleTime;

        walkRun_TreeVal_X = Mathf.Cos(time) * walkRunMagnitude;
        walkRun_TreeVal_Y = Mathf.Sin(time) * walkRunMagnitude;

        _myAnimator.SetFloat("BlendX", walkRun_TreeVal_X);
        _myAnimator.SetFloat("BlendY", walkRun_TreeVal_Y);
    }
}
