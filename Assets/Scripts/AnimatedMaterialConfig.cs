using UnityEngine;


[CreateAssetMenu(fileName = "Animated Material Config", menuName = "Config/Animated Material Config", order = 1)]
public class AnimatedMaterialConfig : ScriptableObject
{
    public AnimatedMaterialParameter[] parameters;
}
