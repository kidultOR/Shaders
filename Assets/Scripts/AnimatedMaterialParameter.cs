using UnityEngine;

[System.Serializable]
public class AnimatedMaterialParameter
{
    public enum ParameterType
    {
        Int, Float, Texture
    }
    
    public string parameterName;
    public ParameterType parameterType;
    public float frameRate;
    public AnimationCurve animationCurve;
    public Texture2D spriteSheet;
}