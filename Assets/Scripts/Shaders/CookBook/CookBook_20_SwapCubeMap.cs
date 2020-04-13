using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class CookBook_20_SwapCubeMap : MonoBehaviour
{
    public Cubemap _cube1;
    public Cubemap _cube2;

    public Transform _posA;
    public Transform _posB;

    public Material _curMat;
    public Cubemap _curCube;

    private void OnDrawGizmos()
    {
        if (_posA)
        {
            Gizmos.DrawWireSphere(_posA.position, 0.5f);
        }
        if (_posB)
        {
            Gizmos.DrawWireSphere(_posB.position, 0.5f);
        }
    }

    private Cubemap CheckProbeDistance()
    {
        float _distA = Vector3.Distance(transform.position, _posA.position);
        float _distB = Vector3.Distance(transform.position, _posB.position);
        if(_distA <= _distB)
        {
            return _cube1;
        }
        //else if (_distB < _distA)
        else
        {
            return _cube2;
        }
    }

    //private void Start()
    //{
    //    _curMat = GetComponent<Material>();
    //}

    private void Update()
    {
        //_curMat = 
        _curCube = CheckProbeDistance();
        _curMat.SetTexture("_Cubemap", _curCube);
    }
}
