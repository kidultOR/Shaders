Shader "shaderLab/diffuse"{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
    }
    SubShader{
        Pass{
            Matrial{
                Diffuse [_Color]
            }
            Lighting On
        }
    }
}