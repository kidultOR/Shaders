using UnityEngine;
using UnityEditor;

public class MyLightingShaderGUI_10_ : ShaderGUI
{
    Material target;
    MaterialEditor editor;
    MaterialProperty[] properties;

    enum SmoothnessSource
    {
        Uniform, 
        Albedo, 
        Metallic
    }

    [System.Obsolete]
    static ColorPickerHDRConfig emissionConfig = new ColorPickerHDRConfig(0f, 99f, 1f / 99f, 3f);


    public override void OnGUI(MaterialEditor editor, MaterialProperty[] properties)
    {
        this.target = editor.target as Material;
        this.editor = editor;
        this.properties = properties;
        DoMain();
        DoSecondary();
    }


    void RecordAction(string label)
    {
        editor.RegisterPropertyChangeUndo(label);
    }

    bool IsKeywordEnabled(string keyword)
    {
        return target.IsKeywordEnabled(keyword);
    }

    static GUIContent staticLabel = new GUIContent();

    void SetKeyword(string keyword, bool state)
    {
        if (state)
        {
            target.EnableKeyword(keyword);
        }
        else
        {
            target.DisableKeyword(keyword);
        }
    }

    static GUIContent MakeLabel (string text, string tooltip = null)
    {
        staticLabel.text = text;
        staticLabel.tooltip = tooltip;
        return staticLabel;
    }

    static GUIContent MakeLabel (MaterialProperty property, string tooltip = null)
    {
        staticLabel.text = property.displayName;
        staticLabel.tooltip = tooltip;
        return staticLabel;
    }

    MaterialProperty FindProperty(string name)
    {
        return FindProperty(name, properties);
    }

    void DoNormals()
    {
        MaterialProperty map = FindProperty("_NormalMap");
        Texture tex = map.textureValue;
        EditorGUI.BeginChangeCheck();
        editor.TexturePropertySingleLine(MakeLabel(map), map, tex ? FindProperty("_BumpScale"): null);
        if (EditorGUI.EndChangeCheck() && tex!= map.textureValue)
        {
            SetKeyword("_NORMAL_MAP", map.textureValue)
;        }
    }

    void DoMetallic()
    {
        MaterialProperty map = FindProperty("_MetallicMap");
        EditorGUI.BeginChangeCheck();
        editor.TexturePropertySingleLine(MakeLabel(map), map, map.textureValue ? null : FindProperty("_Metallic"));
        if (EditorGUI.EndChangeCheck())
        {
            SetKeyword("_METALLIC_MAP", map.textureValue);
        }
    }

    void DoSmoothness()
    {
        SmoothnessSource source = SmoothnessSource.Uniform;
        if (target.IsKeywordEnabled("_SMOOTHNESS_ALBEDO"))
        {
            source = SmoothnessSource.Albedo;
        }
        else if (target.IsKeywordEnabled("_SMOOTHNESS_METALLIC"))
        {
            source = SmoothnessSource.Metallic;
        }
        MaterialProperty slider = FindProperty("_Smoothness");
        EditorGUI.indentLevel += 2;
        editor.ShaderProperty(slider, MakeLabel(slider));
        EditorGUI.indentLevel += 1;
        EditorGUI.BeginChangeCheck();
        source = (SmoothnessSource)EditorGUILayout.EnumPopup(MakeLabel("Source"), source);
        if(EditorGUI.EndChangeCheck())
        {
            RecordAction("Smoothness Source");
            SetKeyword("_SMOOTHNESS_ALBEDO", source == SmoothnessSource.Albedo);
            SetKeyword("_SMOOTHNESS_METALLIC", source == SmoothnessSource.Metallic);
        }
        EditorGUI.indentLevel -= 3;
    }

    void DoEmission()
    {
        MaterialProperty map = FindProperty("_EmissionMap");
        EditorGUI.BeginChangeCheck();
        editor.TexturePropertyWithHDRColor(
            MakeLabel(map),
            map,
            FindProperty("_Emission"),
            //emissionConfig,
            false
        );
        if (EditorGUI.EndChangeCheck())
        {
            SetKeyword("_EMISSION_MAP", map.textureValue);
        }
    }

    void DoOcclusion()
    {
        MaterialProperty map = FindProperty("_OcclusionMap");
        EditorGUI.BeginChangeCheck();
        editor.TexturePropertySingleLine(
            MakeLabel(map),
            map,
            map.textureValue ? FindProperty("_OcclusionStrength") : null);
        if (EditorGUI.EndChangeCheck())
        {
            SetKeyword("_OCCLUSION_MAP", map.textureValue);
        }
    }

    void DoDetailMask()
    {
        MaterialProperty map = FindProperty("_DetailMask");
        EditorGUI.BeginChangeCheck();
        editor.TexturePropertySingleLine(MakeLabel(map), map);
        if (EditorGUI.EndChangeCheck())
        {
            SetKeyword("_DETAIL_MASK", map.textureValue);
        }
    }

    //void CreateMap (string name, MaterialProperty additional = null)
    //{
    //    MaterialProperty property = FindProperty(name);
    //    editor.TexturePropertySingleLine(MakeLabel(property), property, additional);
    //}

    void DoMain()
    {
        GUILayout.Label("Main Map", EditorStyles.boldLabel);
        MaterialProperty _mainTex = FindProperty("_MainTex");
        MaterialProperty _tint = FindProperty("_Tint");
        editor.TexturePropertySingleLine(MakeLabel(_mainTex), _mainTex, _tint);
        DoMetallic();
        DoSmoothness();
        DoNormals();
        DoEmission();
        DoOcclusion();
        DoDetailMask();
        EditorGUI.indentLevel += 2;
        editor.TextureScaleOffsetProperty(_mainTex);
        EditorGUI.indentLevel -= 2;
    }

    void DoSecondaryNormals()
    {
        MaterialProperty map = FindProperty("_DetailNormalMap");
        EditorGUI.BeginChangeCheck();
        editor.TexturePropertySingleLine( MakeLabel(map), map, map.textureValue ? FindProperty("_DetailBumpScale") : null );
        if (EditorGUI.EndChangeCheck());
        {
            SetKeyword("_DETAIL_NORMAL_MAP", map.textureValue);
        }
    }

    void DoSecondary()
    {
        GUILayout.Space(5);
        
        GUILayout.Label("Secondary Map", EditorStyles.boldLabel);
        MaterialProperty detailTex = FindProperty("_DetailTex");

        EditorGUI.BeginChangeCheck();
        editor.TexturePropertySingleLine(MakeLabel(detailTex, "Albedo (RGB) multiplied by 2"), detailTex);
        if (EditorGUI.EndChangeCheck())
        {
            SetKeyword("_DETAIL_ALBEDO_MAP", detailTex.textureValue);
        }

        DoSecondaryNormals();
        EditorGUI.indentLevel += 2;
        editor.TextureScaleOffsetProperty(detailTex);
        EditorGUI.indentLevel -= 2;
    }

}