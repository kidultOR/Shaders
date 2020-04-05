using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CookBook_6_SpriteList : MonoBehaviour
{
    public Material _material;
    private float _timeValue;
    private float _speed;
    private float _cellAmount;

    // Start is called before the first frame update
    void Start()
    {
        _cellAmount = _material.GetFloat("_CellAmount");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void FixedUpdate()
    {
        _speed = _material.GetFloat("_Speed");
        _timeValue = Mathf.Ceil((Time.time*_speed) % _cellAmount);
        _material.SetFloat("_TimeValue", _timeValue);
    }
}
