Shader "GameUse/Cloud Shader"
{
    Properties
    {
        Vector4_B8501A8F("Position Projection", Vector) = (1, 0, 0, 0)
        Vector1_10BA39AF("Noise Scale", Float) = 10
        Vector1_878BB938("Rolling Speed", Float) = 0.1
        Vector1_2E16E1AA("Cloud Height", Float) = 1
        Vector4_76C337AB("Normal Remapping", Vector) = (0, 1, -1, 1)
        Color_49648F3("Cloud Top Color", Color) = (1, 1, 1, 0)
        Color_FC73A812("Cloud Bottom Color", Color) = (0, 0, 0, 0)
        Vector2_E9CE62C2("Smooth Step Control", Vector) = (0, 1, 0, 0)
        Vector1_E01DB932("Noise Power", Float) = 1
        Vector1_E4C3970F("Base Layer Scale", Float) = 1
        Vector1_752EF9AE("Base Layer Speed", Float) = 1
        Vector1_E6B27546("Base Layer Strength", Float) = 1
        Vector1_2E7480A6("Emission", Float) = 1
        Vector1_EDF9F2F0("Curve Radius", Float) = 1
        Vector1_3E6B7FE7("Fresnel Power", Float) = 4
        Vector1_39EBEC6D("Fresnel Opacity", Float) = 1
        Vector1_52AA6CA7("Cloud Strength", Float) = 100
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            Name "Universal Forward"
            Tags 
            { 
                "LightMode" = "UniversalForward"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            //ZWrite On, You should tweak it off when something went wrong
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_BITANGENT_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_FORWARD
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_B8501A8F;
            float Vector1_10BA39AF;
            float Vector1_878BB938;
            float Vector1_2E16E1AA;
            float4 Vector4_76C337AB;
            float4 Color_49648F3;
            float4 Color_FC73A812;
            float2 Vector2_E9CE62C2;
            float Vector1_E01DB932;
            float Vector1_E4C3970F;
            float Vector1_752EF9AE;
            float Vector1_E6B27546;
            float Vector1_2E7480A6;
            float Vector1_EDF9F2F0;
            float Vector1_3E6B7FE7;
            float Vector1_39EBEC6D;
            float Vector1_52AA6CA7;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_AEBF83C4_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_AEBF83C4_Out_2);
                float _Property_80F2B000_Out_0 = Vector1_EDF9F2F0;
                float _Divide_B212473D_Out_2;
                Unity_Divide_float(_Distance_AEBF83C4_Out_2, _Property_80F2B000_Out_0, _Divide_B212473D_Out_2);
                float _Power_D56B9DD9_Out_2;
                Unity_Power_float(_Divide_B212473D_Out_2, 3, _Power_D56B9DD9_Out_2);
                float3 _Multiply_ADEF0A19_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_D56B9DD9_Out_2.xxx), _Multiply_ADEF0A19_Out_2);
                float _Property_522D030F_Out_0 = Vector1_2E16E1AA;
                float2 _Property_BD0E2DDD_Out_0 = Vector2_E9CE62C2;
                float _Split_A93B8B1_R_1 = _Property_BD0E2DDD_Out_0[0];
                float _Split_A93B8B1_G_2 = _Property_BD0E2DDD_Out_0[1];
                float _Split_A93B8B1_B_3 = 0;
                float _Split_A93B8B1_A_4 = 0;
                float4 _Property_85A96D15_Out_0 = Vector4_B8501A8F;
                float _Split_358AA511_R_1 = _Property_85A96D15_Out_0[0];
                float _Split_358AA511_G_2 = _Property_85A96D15_Out_0[1];
                float _Split_358AA511_B_3 = _Property_85A96D15_Out_0[2];
                float _Split_358AA511_A_4 = _Property_85A96D15_Out_0[3];
                float3 _RotateAboutAxis_907A089F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_85A96D15_Out_0.xyz), _Split_358AA511_A_4, _RotateAboutAxis_907A089F_Out_3);
                float _Property_23C8CA7F_Out_0 = Vector1_878BB938;
                float _Multiply_864407E5_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_23C8CA7F_Out_0, _Multiply_864407E5_Out_2);
                float2 _TilingAndOffset_A1864C48_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_864407E5_Out_2.xx), _TilingAndOffset_A1864C48_Out_3);
                float _Property_37D643D8_Out_0 = Vector1_10BA39AF;
                float _GradientNoise_E0CCC673_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_A1864C48_Out_3, _Property_37D643D8_Out_0, _GradientNoise_E0CCC673_Out_2);
                float2 _TilingAndOffset_24C848AB_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_24C848AB_Out_3);
                float _GradientNoise_A84E235C_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_24C848AB_Out_3, _Property_37D643D8_Out_0, _GradientNoise_A84E235C_Out_2);
                float _Add_AEEC6F8E_Out_2;
                Unity_Add_float(_GradientNoise_E0CCC673_Out_2, _GradientNoise_A84E235C_Out_2, _Add_AEEC6F8E_Out_2);
                float _Divide_A316E786_Out_2;
                Unity_Divide_float(_Add_AEEC6F8E_Out_2, 2, _Divide_A316E786_Out_2);
                float _Saturate_1DE67959_Out_1;
                Unity_Saturate_float(_Divide_A316E786_Out_2, _Saturate_1DE67959_Out_1);
                float _Property_C7056210_Out_0 = Vector1_E01DB932;
                float _Power_9D56A5DF_Out_2;
                Unity_Power_float(_Saturate_1DE67959_Out_1, _Property_C7056210_Out_0, _Power_9D56A5DF_Out_2);
                float4 _Property_73C84E5_Out_0 = Vector4_76C337AB;
                float _Split_18B1DD64_R_1 = _Property_73C84E5_Out_0[0];
                float _Split_18B1DD64_G_2 = _Property_73C84E5_Out_0[1];
                float _Split_18B1DD64_B_3 = _Property_73C84E5_Out_0[2];
                float _Split_18B1DD64_A_4 = _Property_73C84E5_Out_0[3];
                float4 _Combine_4D21EBAF_RGBA_4;
                float3 _Combine_4D21EBAF_RGB_5;
                float2 _Combine_4D21EBAF_RG_6;
                Unity_Combine_float(_Split_18B1DD64_R_1, _Split_18B1DD64_G_2, 0, 0, _Combine_4D21EBAF_RGBA_4, _Combine_4D21EBAF_RGB_5, _Combine_4D21EBAF_RG_6);
                float4 _Combine_F4FD313C_RGBA_4;
                float3 _Combine_F4FD313C_RGB_5;
                float2 _Combine_F4FD313C_RG_6;
                Unity_Combine_float(_Split_18B1DD64_B_3, _Split_18B1DD64_A_4, 0, 0, _Combine_F4FD313C_RGBA_4, _Combine_F4FD313C_RGB_5, _Combine_F4FD313C_RG_6);
                float _Remap_94589653_Out_3;
                Unity_Remap_float(_Power_9D56A5DF_Out_2, _Combine_4D21EBAF_RG_6, _Combine_F4FD313C_RG_6, _Remap_94589653_Out_3);
                float _Absolute_C268146C_Out_1;
                Unity_Absolute_float(_Remap_94589653_Out_3, _Absolute_C268146C_Out_1);
                float _Smoothstep_F5D12A88_Out_3;
                Unity_Smoothstep_float(_Split_A93B8B1_R_1, _Split_A93B8B1_G_2, _Absolute_C268146C_Out_1, _Smoothstep_F5D12A88_Out_3);
                float _Property_1E82AAE4_Out_0 = Vector1_752EF9AE;
                float _Multiply_399758E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_1E82AAE4_Out_0, _Multiply_399758E0_Out_2);
                float2 _TilingAndOffset_517D525_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_399758E0_Out_2.xx), _TilingAndOffset_517D525_Out_3);
                float _Property_8DAC5AF3_Out_0 = Vector1_E4C3970F;
                float _GradientNoise_7487AB70_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_517D525_Out_3, _Property_8DAC5AF3_Out_0, _GradientNoise_7487AB70_Out_2);
                float _Property_F19089BF_Out_0 = Vector1_E6B27546;
                float _Multiply_E0B23D13_Out_2;
                Unity_Multiply_float(_GradientNoise_7487AB70_Out_2, _Property_F19089BF_Out_0, _Multiply_E0B23D13_Out_2);
                float _Add_AEB01DBA_Out_2;
                Unity_Add_float(_Smoothstep_F5D12A88_Out_3, _Multiply_E0B23D13_Out_2, _Add_AEB01DBA_Out_2);
                float _Add_1795A0B4_Out_2;
                Unity_Add_float(1, _Property_F19089BF_Out_0, _Add_1795A0B4_Out_2);
                float _Divide_CD48AB3B_Out_2;
                Unity_Divide_float(_Add_AEB01DBA_Out_2, _Add_1795A0B4_Out_2, _Divide_CD48AB3B_Out_2);
                float3 _Multiply_92087194_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_CD48AB3B_Out_2.xxx), _Multiply_92087194_Out_2);
                float3 _Multiply_C73EE6E6_Out_2;
                Unity_Multiply_float((_Property_522D030F_Out_0.xxx), _Multiply_92087194_Out_2, _Multiply_C73EE6E6_Out_2);
                float3 _Add_3DA86599_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_C73EE6E6_Out_2, _Add_3DA86599_Out_2);
                float3 _Add_AA4400A1_Out_2;
                Unity_Add_float3(_Multiply_ADEF0A19_Out_2, _Add_3DA86599_Out_2, _Add_AA4400A1_Out_2);
                description.VertexPosition = _Add_AA4400A1_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 TangentSpaceNormal;
                float3 WorldSpaceViewDirection;
                float3 WorldSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Albedo;
                float3 Normal;
                float3 Emission;
                float Metallic;
                float Smoothness;
                float Occlusion;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_3267874D_Out_0 = Color_49648F3;
                float4 _Property_874386B5_Out_0 = Color_FC73A812;
                float2 _Property_BD0E2DDD_Out_0 = Vector2_E9CE62C2;
                float _Split_A93B8B1_R_1 = _Property_BD0E2DDD_Out_0[0];
                float _Split_A93B8B1_G_2 = _Property_BD0E2DDD_Out_0[1];
                float _Split_A93B8B1_B_3 = 0;
                float _Split_A93B8B1_A_4 = 0;
                float4 _Property_85A96D15_Out_0 = Vector4_B8501A8F;
                float _Split_358AA511_R_1 = _Property_85A96D15_Out_0[0];
                float _Split_358AA511_G_2 = _Property_85A96D15_Out_0[1];
                float _Split_358AA511_B_3 = _Property_85A96D15_Out_0[2];
                float _Split_358AA511_A_4 = _Property_85A96D15_Out_0[3];
                float3 _RotateAboutAxis_907A089F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_85A96D15_Out_0.xyz), _Split_358AA511_A_4, _RotateAboutAxis_907A089F_Out_3);
                float _Property_23C8CA7F_Out_0 = Vector1_878BB938;
                float _Multiply_864407E5_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_23C8CA7F_Out_0, _Multiply_864407E5_Out_2);
                float2 _TilingAndOffset_A1864C48_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_864407E5_Out_2.xx), _TilingAndOffset_A1864C48_Out_3);
                float _Property_37D643D8_Out_0 = Vector1_10BA39AF;
                float _GradientNoise_E0CCC673_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_A1864C48_Out_3, _Property_37D643D8_Out_0, _GradientNoise_E0CCC673_Out_2);
                float2 _TilingAndOffset_24C848AB_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_24C848AB_Out_3);
                float _GradientNoise_A84E235C_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_24C848AB_Out_3, _Property_37D643D8_Out_0, _GradientNoise_A84E235C_Out_2);
                float _Add_AEEC6F8E_Out_2;
                Unity_Add_float(_GradientNoise_E0CCC673_Out_2, _GradientNoise_A84E235C_Out_2, _Add_AEEC6F8E_Out_2);
                float _Divide_A316E786_Out_2;
                Unity_Divide_float(_Add_AEEC6F8E_Out_2, 2, _Divide_A316E786_Out_2);
                float _Saturate_1DE67959_Out_1;
                Unity_Saturate_float(_Divide_A316E786_Out_2, _Saturate_1DE67959_Out_1);
                float _Property_C7056210_Out_0 = Vector1_E01DB932;
                float _Power_9D56A5DF_Out_2;
                Unity_Power_float(_Saturate_1DE67959_Out_1, _Property_C7056210_Out_0, _Power_9D56A5DF_Out_2);
                float4 _Property_73C84E5_Out_0 = Vector4_76C337AB;
                float _Split_18B1DD64_R_1 = _Property_73C84E5_Out_0[0];
                float _Split_18B1DD64_G_2 = _Property_73C84E5_Out_0[1];
                float _Split_18B1DD64_B_3 = _Property_73C84E5_Out_0[2];
                float _Split_18B1DD64_A_4 = _Property_73C84E5_Out_0[3];
                float4 _Combine_4D21EBAF_RGBA_4;
                float3 _Combine_4D21EBAF_RGB_5;
                float2 _Combine_4D21EBAF_RG_6;
                Unity_Combine_float(_Split_18B1DD64_R_1, _Split_18B1DD64_G_2, 0, 0, _Combine_4D21EBAF_RGBA_4, _Combine_4D21EBAF_RGB_5, _Combine_4D21EBAF_RG_6);
                float4 _Combine_F4FD313C_RGBA_4;
                float3 _Combine_F4FD313C_RGB_5;
                float2 _Combine_F4FD313C_RG_6;
                Unity_Combine_float(_Split_18B1DD64_B_3, _Split_18B1DD64_A_4, 0, 0, _Combine_F4FD313C_RGBA_4, _Combine_F4FD313C_RGB_5, _Combine_F4FD313C_RG_6);
                float _Remap_94589653_Out_3;
                Unity_Remap_float(_Power_9D56A5DF_Out_2, _Combine_4D21EBAF_RG_6, _Combine_F4FD313C_RG_6, _Remap_94589653_Out_3);
                float _Absolute_C268146C_Out_1;
                Unity_Absolute_float(_Remap_94589653_Out_3, _Absolute_C268146C_Out_1);
                float _Smoothstep_F5D12A88_Out_3;
                Unity_Smoothstep_float(_Split_A93B8B1_R_1, _Split_A93B8B1_G_2, _Absolute_C268146C_Out_1, _Smoothstep_F5D12A88_Out_3);
                float _Property_1E82AAE4_Out_0 = Vector1_752EF9AE;
                float _Multiply_399758E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_1E82AAE4_Out_0, _Multiply_399758E0_Out_2);
                float2 _TilingAndOffset_517D525_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_399758E0_Out_2.xx), _TilingAndOffset_517D525_Out_3);
                float _Property_8DAC5AF3_Out_0 = Vector1_E4C3970F;
                float _GradientNoise_7487AB70_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_517D525_Out_3, _Property_8DAC5AF3_Out_0, _GradientNoise_7487AB70_Out_2);
                float _Property_F19089BF_Out_0 = Vector1_E6B27546;
                float _Multiply_E0B23D13_Out_2;
                Unity_Multiply_float(_GradientNoise_7487AB70_Out_2, _Property_F19089BF_Out_0, _Multiply_E0B23D13_Out_2);
                float _Add_AEB01DBA_Out_2;
                Unity_Add_float(_Smoothstep_F5D12A88_Out_3, _Multiply_E0B23D13_Out_2, _Add_AEB01DBA_Out_2);
                float _Add_1795A0B4_Out_2;
                Unity_Add_float(1, _Property_F19089BF_Out_0, _Add_1795A0B4_Out_2);
                float _Divide_CD48AB3B_Out_2;
                Unity_Divide_float(_Add_AEB01DBA_Out_2, _Add_1795A0B4_Out_2, _Divide_CD48AB3B_Out_2);
                float4 _Lerp_3CFA9689_Out_3;
                Unity_Lerp_float4(_Property_3267874D_Out_0, _Property_874386B5_Out_0, (_Divide_CD48AB3B_Out_2.xxxx), _Lerp_3CFA9689_Out_3);
                float _Property_B694290A_Out_0 = Vector1_3E6B7FE7;
                float _FresnelEffect_34957A66_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_B694290A_Out_0, _FresnelEffect_34957A66_Out_3);
                float _Multiply_7F434B16_Out_2;
                Unity_Multiply_float(_Divide_CD48AB3B_Out_2, _FresnelEffect_34957A66_Out_3, _Multiply_7F434B16_Out_2);
                float _Property_B24F300B_Out_0 = Vector1_39EBEC6D;
                float _Multiply_D541942D_Out_2;
                Unity_Multiply_float(_Multiply_7F434B16_Out_2, _Property_B24F300B_Out_0, _Multiply_D541942D_Out_2);
                float4 _Add_8E00908D_Out_2;
                Unity_Add_float4(_Lerp_3CFA9689_Out_3, (_Multiply_D541942D_Out_2.xxxx), _Add_8E00908D_Out_2);
                float _Property_94EB74B0_Out_0 = Vector1_2E7480A6;
                float4 _Multiply_E3794236_Out_2;
                Unity_Multiply_float(_Add_8E00908D_Out_2, (_Property_94EB74B0_Out_0.xxxx), _Multiply_E3794236_Out_2);
                float _SceneDepth_E7ABEF40_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_E7ABEF40_Out_1);
                float4 _ScreenPosition_46B36936_Out_0 = IN.ScreenPosition;
                float _Split_73EB913D_R_1 = _ScreenPosition_46B36936_Out_0[0];
                float _Split_73EB913D_G_2 = _ScreenPosition_46B36936_Out_0[1];
                float _Split_73EB913D_B_3 = _ScreenPosition_46B36936_Out_0[2];
                float _Split_73EB913D_A_4 = _ScreenPosition_46B36936_Out_0[3];
                float _Subtract_391EEEFB_Out_2;
                Unity_Subtract_float(_Split_73EB913D_A_4, 1, _Subtract_391EEEFB_Out_2);
                float _Subtract_C73106_Out_2;
                Unity_Subtract_float(_SceneDepth_E7ABEF40_Out_1, _Subtract_391EEEFB_Out_2, _Subtract_C73106_Out_2);
                float _Property_DD1B1629_Out_0 = Vector1_52AA6CA7;
                float _Divide_EA86155F_Out_2;
                Unity_Divide_float(_Subtract_C73106_Out_2, _Property_DD1B1629_Out_0, _Divide_EA86155F_Out_2);
                float _Saturate_BF09143D_Out_1;
                Unity_Saturate_float(_Divide_EA86155F_Out_2, _Saturate_BF09143D_Out_1);
                float _Smoothstep_86D32FA4_Out_3;
                Unity_Smoothstep_float(0, 1, _Saturate_BF09143D_Out_1, _Smoothstep_86D32FA4_Out_3);
                surface.Albedo = (_Add_8E00908D_Out_2.xyz);
                surface.Normal = IN.TangentSpaceNormal;
                surface.Emission = (_Multiply_E3794236_Out_2.xyz);
                surface.Metallic = 0;
                surface.Smoothness = 0.5;
                surface.Occlusion = 1;
                surface.Alpha = _Smoothstep_86D32FA4_Out_3;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv1 : TEXCOORD1;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                float3 normalWS;
                float4 tangentWS;
                float3 viewDirectionWS;
                float3 bitangentWS;
                #if defined(LIGHTMAP_ON)
                float2 lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                float3 sh;
                #endif
                float4 fogFactorAndVertexLight;
                float4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if defined(LIGHTMAP_ON)
                #endif
                #if !defined(LIGHTMAP_ON)
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                float3 interp03 : TEXCOORD3;
                float3 interp04 : TEXCOORD4;
                float2 interp05 : TEXCOORD5;
                float3 interp06 : TEXCOORD6;
                float4 interp07 : TEXCOORD7;
                float4 interp08 : TEXCOORD8;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyz = input.viewDirectionWS;
                output.interp04.xyz = input.bitangentWS;
                #if defined(LIGHTMAP_ON)
                output.interp05.xy = input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp06.xyz = input.sh;
                #endif
                output.interp07.xyzw = input.fogFactorAndVertexLight;
                output.interp08.xyzw = input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.viewDirectionWS = input.interp03.xyz;
                output.bitangentWS = input.interp04.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp05.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp06.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp07.xyzw;
                output.shadowCoord = input.interp08.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.WorldSpaceNormal =            input.normalWS;
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.WorldSpacePosition =          input.positionWS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "ShadowCaster"
            Tags 
            { 
                "LightMode" = "ShadowCaster"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_SHADOWCASTER
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_B8501A8F;
            float Vector1_10BA39AF;
            float Vector1_878BB938;
            float Vector1_2E16E1AA;
            float4 Vector4_76C337AB;
            float4 Color_49648F3;
            float4 Color_FC73A812;
            float2 Vector2_E9CE62C2;
            float Vector1_E01DB932;
            float Vector1_E4C3970F;
            float Vector1_752EF9AE;
            float Vector1_E6B27546;
            float Vector1_2E7480A6;
            float Vector1_EDF9F2F0;
            float Vector1_3E6B7FE7;
            float Vector1_39EBEC6D;
            float Vector1_52AA6CA7;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_AEBF83C4_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_AEBF83C4_Out_2);
                float _Property_80F2B000_Out_0 = Vector1_EDF9F2F0;
                float _Divide_B212473D_Out_2;
                Unity_Divide_float(_Distance_AEBF83C4_Out_2, _Property_80F2B000_Out_0, _Divide_B212473D_Out_2);
                float _Power_D56B9DD9_Out_2;
                Unity_Power_float(_Divide_B212473D_Out_2, 3, _Power_D56B9DD9_Out_2);
                float3 _Multiply_ADEF0A19_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_D56B9DD9_Out_2.xxx), _Multiply_ADEF0A19_Out_2);
                float _Property_522D030F_Out_0 = Vector1_2E16E1AA;
                float2 _Property_BD0E2DDD_Out_0 = Vector2_E9CE62C2;
                float _Split_A93B8B1_R_1 = _Property_BD0E2DDD_Out_0[0];
                float _Split_A93B8B1_G_2 = _Property_BD0E2DDD_Out_0[1];
                float _Split_A93B8B1_B_3 = 0;
                float _Split_A93B8B1_A_4 = 0;
                float4 _Property_85A96D15_Out_0 = Vector4_B8501A8F;
                float _Split_358AA511_R_1 = _Property_85A96D15_Out_0[0];
                float _Split_358AA511_G_2 = _Property_85A96D15_Out_0[1];
                float _Split_358AA511_B_3 = _Property_85A96D15_Out_0[2];
                float _Split_358AA511_A_4 = _Property_85A96D15_Out_0[3];
                float3 _RotateAboutAxis_907A089F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_85A96D15_Out_0.xyz), _Split_358AA511_A_4, _RotateAboutAxis_907A089F_Out_3);
                float _Property_23C8CA7F_Out_0 = Vector1_878BB938;
                float _Multiply_864407E5_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_23C8CA7F_Out_0, _Multiply_864407E5_Out_2);
                float2 _TilingAndOffset_A1864C48_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_864407E5_Out_2.xx), _TilingAndOffset_A1864C48_Out_3);
                float _Property_37D643D8_Out_0 = Vector1_10BA39AF;
                float _GradientNoise_E0CCC673_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_A1864C48_Out_3, _Property_37D643D8_Out_0, _GradientNoise_E0CCC673_Out_2);
                float2 _TilingAndOffset_24C848AB_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_24C848AB_Out_3);
                float _GradientNoise_A84E235C_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_24C848AB_Out_3, _Property_37D643D8_Out_0, _GradientNoise_A84E235C_Out_2);
                float _Add_AEEC6F8E_Out_2;
                Unity_Add_float(_GradientNoise_E0CCC673_Out_2, _GradientNoise_A84E235C_Out_2, _Add_AEEC6F8E_Out_2);
                float _Divide_A316E786_Out_2;
                Unity_Divide_float(_Add_AEEC6F8E_Out_2, 2, _Divide_A316E786_Out_2);
                float _Saturate_1DE67959_Out_1;
                Unity_Saturate_float(_Divide_A316E786_Out_2, _Saturate_1DE67959_Out_1);
                float _Property_C7056210_Out_0 = Vector1_E01DB932;
                float _Power_9D56A5DF_Out_2;
                Unity_Power_float(_Saturate_1DE67959_Out_1, _Property_C7056210_Out_0, _Power_9D56A5DF_Out_2);
                float4 _Property_73C84E5_Out_0 = Vector4_76C337AB;
                float _Split_18B1DD64_R_1 = _Property_73C84E5_Out_0[0];
                float _Split_18B1DD64_G_2 = _Property_73C84E5_Out_0[1];
                float _Split_18B1DD64_B_3 = _Property_73C84E5_Out_0[2];
                float _Split_18B1DD64_A_4 = _Property_73C84E5_Out_0[3];
                float4 _Combine_4D21EBAF_RGBA_4;
                float3 _Combine_4D21EBAF_RGB_5;
                float2 _Combine_4D21EBAF_RG_6;
                Unity_Combine_float(_Split_18B1DD64_R_1, _Split_18B1DD64_G_2, 0, 0, _Combine_4D21EBAF_RGBA_4, _Combine_4D21EBAF_RGB_5, _Combine_4D21EBAF_RG_6);
                float4 _Combine_F4FD313C_RGBA_4;
                float3 _Combine_F4FD313C_RGB_5;
                float2 _Combine_F4FD313C_RG_6;
                Unity_Combine_float(_Split_18B1DD64_B_3, _Split_18B1DD64_A_4, 0, 0, _Combine_F4FD313C_RGBA_4, _Combine_F4FD313C_RGB_5, _Combine_F4FD313C_RG_6);
                float _Remap_94589653_Out_3;
                Unity_Remap_float(_Power_9D56A5DF_Out_2, _Combine_4D21EBAF_RG_6, _Combine_F4FD313C_RG_6, _Remap_94589653_Out_3);
                float _Absolute_C268146C_Out_1;
                Unity_Absolute_float(_Remap_94589653_Out_3, _Absolute_C268146C_Out_1);
                float _Smoothstep_F5D12A88_Out_3;
                Unity_Smoothstep_float(_Split_A93B8B1_R_1, _Split_A93B8B1_G_2, _Absolute_C268146C_Out_1, _Smoothstep_F5D12A88_Out_3);
                float _Property_1E82AAE4_Out_0 = Vector1_752EF9AE;
                float _Multiply_399758E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_1E82AAE4_Out_0, _Multiply_399758E0_Out_2);
                float2 _TilingAndOffset_517D525_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_399758E0_Out_2.xx), _TilingAndOffset_517D525_Out_3);
                float _Property_8DAC5AF3_Out_0 = Vector1_E4C3970F;
                float _GradientNoise_7487AB70_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_517D525_Out_3, _Property_8DAC5AF3_Out_0, _GradientNoise_7487AB70_Out_2);
                float _Property_F19089BF_Out_0 = Vector1_E6B27546;
                float _Multiply_E0B23D13_Out_2;
                Unity_Multiply_float(_GradientNoise_7487AB70_Out_2, _Property_F19089BF_Out_0, _Multiply_E0B23D13_Out_2);
                float _Add_AEB01DBA_Out_2;
                Unity_Add_float(_Smoothstep_F5D12A88_Out_3, _Multiply_E0B23D13_Out_2, _Add_AEB01DBA_Out_2);
                float _Add_1795A0B4_Out_2;
                Unity_Add_float(1, _Property_F19089BF_Out_0, _Add_1795A0B4_Out_2);
                float _Divide_CD48AB3B_Out_2;
                Unity_Divide_float(_Add_AEB01DBA_Out_2, _Add_1795A0B4_Out_2, _Divide_CD48AB3B_Out_2);
                float3 _Multiply_92087194_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_CD48AB3B_Out_2.xxx), _Multiply_92087194_Out_2);
                float3 _Multiply_C73EE6E6_Out_2;
                Unity_Multiply_float((_Property_522D030F_Out_0.xxx), _Multiply_92087194_Out_2, _Multiply_C73EE6E6_Out_2);
                float3 _Add_3DA86599_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_C73EE6E6_Out_2, _Add_3DA86599_Out_2);
                float3 _Add_AA4400A1_Out_2;
                Unity_Add_float3(_Multiply_ADEF0A19_Out_2, _Add_3DA86599_Out_2, _Add_AA4400A1_Out_2);
                description.VertexPosition = _Add_AA4400A1_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 TangentSpaceNormal;
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_E7ABEF40_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_E7ABEF40_Out_1);
                float4 _ScreenPosition_46B36936_Out_0 = IN.ScreenPosition;
                float _Split_73EB913D_R_1 = _ScreenPosition_46B36936_Out_0[0];
                float _Split_73EB913D_G_2 = _ScreenPosition_46B36936_Out_0[1];
                float _Split_73EB913D_B_3 = _ScreenPosition_46B36936_Out_0[2];
                float _Split_73EB913D_A_4 = _ScreenPosition_46B36936_Out_0[3];
                float _Subtract_391EEEFB_Out_2;
                Unity_Subtract_float(_Split_73EB913D_A_4, 1, _Subtract_391EEEFB_Out_2);
                float _Subtract_C73106_Out_2;
                Unity_Subtract_float(_SceneDepth_E7ABEF40_Out_1, _Subtract_391EEEFB_Out_2, _Subtract_C73106_Out_2);
                float _Property_DD1B1629_Out_0 = Vector1_52AA6CA7;
                float _Divide_EA86155F_Out_2;
                Unity_Divide_float(_Subtract_C73106_Out_2, _Property_DD1B1629_Out_0, _Divide_EA86155F_Out_2);
                float _Saturate_BF09143D_Out_1;
                Unity_Saturate_float(_Divide_EA86155F_Out_2, _Saturate_BF09143D_Out_1);
                float _Smoothstep_86D32FA4_Out_3;
                Unity_Smoothstep_float(0, 1, _Saturate_BF09143D_Out_1, _Smoothstep_86D32FA4_Out_3);
                surface.Alpha = _Smoothstep_86D32FA4_Out_3;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "DepthOnly"
            Tags 
            { 
                "LightMode" = "DepthOnly"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            ColorMask 0
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_DEPTHONLY
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_B8501A8F;
            float Vector1_10BA39AF;
            float Vector1_878BB938;
            float Vector1_2E16E1AA;
            float4 Vector4_76C337AB;
            float4 Color_49648F3;
            float4 Color_FC73A812;
            float2 Vector2_E9CE62C2;
            float Vector1_E01DB932;
            float Vector1_E4C3970F;
            float Vector1_752EF9AE;
            float Vector1_E6B27546;
            float Vector1_2E7480A6;
            float Vector1_EDF9F2F0;
            float Vector1_3E6B7FE7;
            float Vector1_39EBEC6D;
            float Vector1_52AA6CA7;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_AEBF83C4_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_AEBF83C4_Out_2);
                float _Property_80F2B000_Out_0 = Vector1_EDF9F2F0;
                float _Divide_B212473D_Out_2;
                Unity_Divide_float(_Distance_AEBF83C4_Out_2, _Property_80F2B000_Out_0, _Divide_B212473D_Out_2);
                float _Power_D56B9DD9_Out_2;
                Unity_Power_float(_Divide_B212473D_Out_2, 3, _Power_D56B9DD9_Out_2);
                float3 _Multiply_ADEF0A19_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_D56B9DD9_Out_2.xxx), _Multiply_ADEF0A19_Out_2);
                float _Property_522D030F_Out_0 = Vector1_2E16E1AA;
                float2 _Property_BD0E2DDD_Out_0 = Vector2_E9CE62C2;
                float _Split_A93B8B1_R_1 = _Property_BD0E2DDD_Out_0[0];
                float _Split_A93B8B1_G_2 = _Property_BD0E2DDD_Out_0[1];
                float _Split_A93B8B1_B_3 = 0;
                float _Split_A93B8B1_A_4 = 0;
                float4 _Property_85A96D15_Out_0 = Vector4_B8501A8F;
                float _Split_358AA511_R_1 = _Property_85A96D15_Out_0[0];
                float _Split_358AA511_G_2 = _Property_85A96D15_Out_0[1];
                float _Split_358AA511_B_3 = _Property_85A96D15_Out_0[2];
                float _Split_358AA511_A_4 = _Property_85A96D15_Out_0[3];
                float3 _RotateAboutAxis_907A089F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_85A96D15_Out_0.xyz), _Split_358AA511_A_4, _RotateAboutAxis_907A089F_Out_3);
                float _Property_23C8CA7F_Out_0 = Vector1_878BB938;
                float _Multiply_864407E5_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_23C8CA7F_Out_0, _Multiply_864407E5_Out_2);
                float2 _TilingAndOffset_A1864C48_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_864407E5_Out_2.xx), _TilingAndOffset_A1864C48_Out_3);
                float _Property_37D643D8_Out_0 = Vector1_10BA39AF;
                float _GradientNoise_E0CCC673_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_A1864C48_Out_3, _Property_37D643D8_Out_0, _GradientNoise_E0CCC673_Out_2);
                float2 _TilingAndOffset_24C848AB_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_24C848AB_Out_3);
                float _GradientNoise_A84E235C_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_24C848AB_Out_3, _Property_37D643D8_Out_0, _GradientNoise_A84E235C_Out_2);
                float _Add_AEEC6F8E_Out_2;
                Unity_Add_float(_GradientNoise_E0CCC673_Out_2, _GradientNoise_A84E235C_Out_2, _Add_AEEC6F8E_Out_2);
                float _Divide_A316E786_Out_2;
                Unity_Divide_float(_Add_AEEC6F8E_Out_2, 2, _Divide_A316E786_Out_2);
                float _Saturate_1DE67959_Out_1;
                Unity_Saturate_float(_Divide_A316E786_Out_2, _Saturate_1DE67959_Out_1);
                float _Property_C7056210_Out_0 = Vector1_E01DB932;
                float _Power_9D56A5DF_Out_2;
                Unity_Power_float(_Saturate_1DE67959_Out_1, _Property_C7056210_Out_0, _Power_9D56A5DF_Out_2);
                float4 _Property_73C84E5_Out_0 = Vector4_76C337AB;
                float _Split_18B1DD64_R_1 = _Property_73C84E5_Out_0[0];
                float _Split_18B1DD64_G_2 = _Property_73C84E5_Out_0[1];
                float _Split_18B1DD64_B_3 = _Property_73C84E5_Out_0[2];
                float _Split_18B1DD64_A_4 = _Property_73C84E5_Out_0[3];
                float4 _Combine_4D21EBAF_RGBA_4;
                float3 _Combine_4D21EBAF_RGB_5;
                float2 _Combine_4D21EBAF_RG_6;
                Unity_Combine_float(_Split_18B1DD64_R_1, _Split_18B1DD64_G_2, 0, 0, _Combine_4D21EBAF_RGBA_4, _Combine_4D21EBAF_RGB_5, _Combine_4D21EBAF_RG_6);
                float4 _Combine_F4FD313C_RGBA_4;
                float3 _Combine_F4FD313C_RGB_5;
                float2 _Combine_F4FD313C_RG_6;
                Unity_Combine_float(_Split_18B1DD64_B_3, _Split_18B1DD64_A_4, 0, 0, _Combine_F4FD313C_RGBA_4, _Combine_F4FD313C_RGB_5, _Combine_F4FD313C_RG_6);
                float _Remap_94589653_Out_3;
                Unity_Remap_float(_Power_9D56A5DF_Out_2, _Combine_4D21EBAF_RG_6, _Combine_F4FD313C_RG_6, _Remap_94589653_Out_3);
                float _Absolute_C268146C_Out_1;
                Unity_Absolute_float(_Remap_94589653_Out_3, _Absolute_C268146C_Out_1);
                float _Smoothstep_F5D12A88_Out_3;
                Unity_Smoothstep_float(_Split_A93B8B1_R_1, _Split_A93B8B1_G_2, _Absolute_C268146C_Out_1, _Smoothstep_F5D12A88_Out_3);
                float _Property_1E82AAE4_Out_0 = Vector1_752EF9AE;
                float _Multiply_399758E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_1E82AAE4_Out_0, _Multiply_399758E0_Out_2);
                float2 _TilingAndOffset_517D525_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_399758E0_Out_2.xx), _TilingAndOffset_517D525_Out_3);
                float _Property_8DAC5AF3_Out_0 = Vector1_E4C3970F;
                float _GradientNoise_7487AB70_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_517D525_Out_3, _Property_8DAC5AF3_Out_0, _GradientNoise_7487AB70_Out_2);
                float _Property_F19089BF_Out_0 = Vector1_E6B27546;
                float _Multiply_E0B23D13_Out_2;
                Unity_Multiply_float(_GradientNoise_7487AB70_Out_2, _Property_F19089BF_Out_0, _Multiply_E0B23D13_Out_2);
                float _Add_AEB01DBA_Out_2;
                Unity_Add_float(_Smoothstep_F5D12A88_Out_3, _Multiply_E0B23D13_Out_2, _Add_AEB01DBA_Out_2);
                float _Add_1795A0B4_Out_2;
                Unity_Add_float(1, _Property_F19089BF_Out_0, _Add_1795A0B4_Out_2);
                float _Divide_CD48AB3B_Out_2;
                Unity_Divide_float(_Add_AEB01DBA_Out_2, _Add_1795A0B4_Out_2, _Divide_CD48AB3B_Out_2);
                float3 _Multiply_92087194_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_CD48AB3B_Out_2.xxx), _Multiply_92087194_Out_2);
                float3 _Multiply_C73EE6E6_Out_2;
                Unity_Multiply_float((_Property_522D030F_Out_0.xxx), _Multiply_92087194_Out_2, _Multiply_C73EE6E6_Out_2);
                float3 _Add_3DA86599_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_C73EE6E6_Out_2, _Add_3DA86599_Out_2);
                float3 _Add_AA4400A1_Out_2;
                Unity_Add_float3(_Multiply_ADEF0A19_Out_2, _Add_3DA86599_Out_2, _Add_AA4400A1_Out_2);
                description.VertexPosition = _Add_AA4400A1_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 TangentSpaceNormal;
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_E7ABEF40_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_E7ABEF40_Out_1);
                float4 _ScreenPosition_46B36936_Out_0 = IN.ScreenPosition;
                float _Split_73EB913D_R_1 = _ScreenPosition_46B36936_Out_0[0];
                float _Split_73EB913D_G_2 = _ScreenPosition_46B36936_Out_0[1];
                float _Split_73EB913D_B_3 = _ScreenPosition_46B36936_Out_0[2];
                float _Split_73EB913D_A_4 = _ScreenPosition_46B36936_Out_0[3];
                float _Subtract_391EEEFB_Out_2;
                Unity_Subtract_float(_Split_73EB913D_A_4, 1, _Subtract_391EEEFB_Out_2);
                float _Subtract_C73106_Out_2;
                Unity_Subtract_float(_SceneDepth_E7ABEF40_Out_1, _Subtract_391EEEFB_Out_2, _Subtract_C73106_Out_2);
                float _Property_DD1B1629_Out_0 = Vector1_52AA6CA7;
                float _Divide_EA86155F_Out_2;
                Unity_Divide_float(_Subtract_C73106_Out_2, _Property_DD1B1629_Out_0, _Divide_EA86155F_Out_2);
                float _Saturate_BF09143D_Out_1;
                Unity_Saturate_float(_Divide_EA86155F_Out_2, _Saturate_BF09143D_Out_1);
                float _Smoothstep_86D32FA4_Out_3;
                Unity_Smoothstep_float(0, 1, _Saturate_BF09143D_Out_1, _Smoothstep_86D32FA4_Out_3);
                surface.Alpha = _Smoothstep_86D32FA4_Out_3;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "Meta"
            Tags 
            { 
                "LightMode" = "Meta"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
        
            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_META
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_B8501A8F;
            float Vector1_10BA39AF;
            float Vector1_878BB938;
            float Vector1_2E16E1AA;
            float4 Vector4_76C337AB;
            float4 Color_49648F3;
            float4 Color_FC73A812;
            float2 Vector2_E9CE62C2;
            float Vector1_E01DB932;
            float Vector1_E4C3970F;
            float Vector1_752EF9AE;
            float Vector1_E6B27546;
            float Vector1_2E7480A6;
            float Vector1_EDF9F2F0;
            float Vector1_3E6B7FE7;
            float Vector1_39EBEC6D;
            float Vector1_52AA6CA7;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_AEBF83C4_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_AEBF83C4_Out_2);
                float _Property_80F2B000_Out_0 = Vector1_EDF9F2F0;
                float _Divide_B212473D_Out_2;
                Unity_Divide_float(_Distance_AEBF83C4_Out_2, _Property_80F2B000_Out_0, _Divide_B212473D_Out_2);
                float _Power_D56B9DD9_Out_2;
                Unity_Power_float(_Divide_B212473D_Out_2, 3, _Power_D56B9DD9_Out_2);
                float3 _Multiply_ADEF0A19_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_D56B9DD9_Out_2.xxx), _Multiply_ADEF0A19_Out_2);
                float _Property_522D030F_Out_0 = Vector1_2E16E1AA;
                float2 _Property_BD0E2DDD_Out_0 = Vector2_E9CE62C2;
                float _Split_A93B8B1_R_1 = _Property_BD0E2DDD_Out_0[0];
                float _Split_A93B8B1_G_2 = _Property_BD0E2DDD_Out_0[1];
                float _Split_A93B8B1_B_3 = 0;
                float _Split_A93B8B1_A_4 = 0;
                float4 _Property_85A96D15_Out_0 = Vector4_B8501A8F;
                float _Split_358AA511_R_1 = _Property_85A96D15_Out_0[0];
                float _Split_358AA511_G_2 = _Property_85A96D15_Out_0[1];
                float _Split_358AA511_B_3 = _Property_85A96D15_Out_0[2];
                float _Split_358AA511_A_4 = _Property_85A96D15_Out_0[3];
                float3 _RotateAboutAxis_907A089F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_85A96D15_Out_0.xyz), _Split_358AA511_A_4, _RotateAboutAxis_907A089F_Out_3);
                float _Property_23C8CA7F_Out_0 = Vector1_878BB938;
                float _Multiply_864407E5_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_23C8CA7F_Out_0, _Multiply_864407E5_Out_2);
                float2 _TilingAndOffset_A1864C48_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_864407E5_Out_2.xx), _TilingAndOffset_A1864C48_Out_3);
                float _Property_37D643D8_Out_0 = Vector1_10BA39AF;
                float _GradientNoise_E0CCC673_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_A1864C48_Out_3, _Property_37D643D8_Out_0, _GradientNoise_E0CCC673_Out_2);
                float2 _TilingAndOffset_24C848AB_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_24C848AB_Out_3);
                float _GradientNoise_A84E235C_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_24C848AB_Out_3, _Property_37D643D8_Out_0, _GradientNoise_A84E235C_Out_2);
                float _Add_AEEC6F8E_Out_2;
                Unity_Add_float(_GradientNoise_E0CCC673_Out_2, _GradientNoise_A84E235C_Out_2, _Add_AEEC6F8E_Out_2);
                float _Divide_A316E786_Out_2;
                Unity_Divide_float(_Add_AEEC6F8E_Out_2, 2, _Divide_A316E786_Out_2);
                float _Saturate_1DE67959_Out_1;
                Unity_Saturate_float(_Divide_A316E786_Out_2, _Saturate_1DE67959_Out_1);
                float _Property_C7056210_Out_0 = Vector1_E01DB932;
                float _Power_9D56A5DF_Out_2;
                Unity_Power_float(_Saturate_1DE67959_Out_1, _Property_C7056210_Out_0, _Power_9D56A5DF_Out_2);
                float4 _Property_73C84E5_Out_0 = Vector4_76C337AB;
                float _Split_18B1DD64_R_1 = _Property_73C84E5_Out_0[0];
                float _Split_18B1DD64_G_2 = _Property_73C84E5_Out_0[1];
                float _Split_18B1DD64_B_3 = _Property_73C84E5_Out_0[2];
                float _Split_18B1DD64_A_4 = _Property_73C84E5_Out_0[3];
                float4 _Combine_4D21EBAF_RGBA_4;
                float3 _Combine_4D21EBAF_RGB_5;
                float2 _Combine_4D21EBAF_RG_6;
                Unity_Combine_float(_Split_18B1DD64_R_1, _Split_18B1DD64_G_2, 0, 0, _Combine_4D21EBAF_RGBA_4, _Combine_4D21EBAF_RGB_5, _Combine_4D21EBAF_RG_6);
                float4 _Combine_F4FD313C_RGBA_4;
                float3 _Combine_F4FD313C_RGB_5;
                float2 _Combine_F4FD313C_RG_6;
                Unity_Combine_float(_Split_18B1DD64_B_3, _Split_18B1DD64_A_4, 0, 0, _Combine_F4FD313C_RGBA_4, _Combine_F4FD313C_RGB_5, _Combine_F4FD313C_RG_6);
                float _Remap_94589653_Out_3;
                Unity_Remap_float(_Power_9D56A5DF_Out_2, _Combine_4D21EBAF_RG_6, _Combine_F4FD313C_RG_6, _Remap_94589653_Out_3);
                float _Absolute_C268146C_Out_1;
                Unity_Absolute_float(_Remap_94589653_Out_3, _Absolute_C268146C_Out_1);
                float _Smoothstep_F5D12A88_Out_3;
                Unity_Smoothstep_float(_Split_A93B8B1_R_1, _Split_A93B8B1_G_2, _Absolute_C268146C_Out_1, _Smoothstep_F5D12A88_Out_3);
                float _Property_1E82AAE4_Out_0 = Vector1_752EF9AE;
                float _Multiply_399758E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_1E82AAE4_Out_0, _Multiply_399758E0_Out_2);
                float2 _TilingAndOffset_517D525_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_399758E0_Out_2.xx), _TilingAndOffset_517D525_Out_3);
                float _Property_8DAC5AF3_Out_0 = Vector1_E4C3970F;
                float _GradientNoise_7487AB70_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_517D525_Out_3, _Property_8DAC5AF3_Out_0, _GradientNoise_7487AB70_Out_2);
                float _Property_F19089BF_Out_0 = Vector1_E6B27546;
                float _Multiply_E0B23D13_Out_2;
                Unity_Multiply_float(_GradientNoise_7487AB70_Out_2, _Property_F19089BF_Out_0, _Multiply_E0B23D13_Out_2);
                float _Add_AEB01DBA_Out_2;
                Unity_Add_float(_Smoothstep_F5D12A88_Out_3, _Multiply_E0B23D13_Out_2, _Add_AEB01DBA_Out_2);
                float _Add_1795A0B4_Out_2;
                Unity_Add_float(1, _Property_F19089BF_Out_0, _Add_1795A0B4_Out_2);
                float _Divide_CD48AB3B_Out_2;
                Unity_Divide_float(_Add_AEB01DBA_Out_2, _Add_1795A0B4_Out_2, _Divide_CD48AB3B_Out_2);
                float3 _Multiply_92087194_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_CD48AB3B_Out_2.xxx), _Multiply_92087194_Out_2);
                float3 _Multiply_C73EE6E6_Out_2;
                Unity_Multiply_float((_Property_522D030F_Out_0.xxx), _Multiply_92087194_Out_2, _Multiply_C73EE6E6_Out_2);
                float3 _Add_3DA86599_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_C73EE6E6_Out_2, _Add_3DA86599_Out_2);
                float3 _Add_AA4400A1_Out_2;
                Unity_Add_float3(_Multiply_ADEF0A19_Out_2, _Add_3DA86599_Out_2, _Add_AA4400A1_Out_2);
                description.VertexPosition = _Add_AA4400A1_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 TangentSpaceNormal;
                float3 WorldSpaceViewDirection;
                float3 WorldSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Albedo;
                float3 Emission;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_3267874D_Out_0 = Color_49648F3;
                float4 _Property_874386B5_Out_0 = Color_FC73A812;
                float2 _Property_BD0E2DDD_Out_0 = Vector2_E9CE62C2;
                float _Split_A93B8B1_R_1 = _Property_BD0E2DDD_Out_0[0];
                float _Split_A93B8B1_G_2 = _Property_BD0E2DDD_Out_0[1];
                float _Split_A93B8B1_B_3 = 0;
                float _Split_A93B8B1_A_4 = 0;
                float4 _Property_85A96D15_Out_0 = Vector4_B8501A8F;
                float _Split_358AA511_R_1 = _Property_85A96D15_Out_0[0];
                float _Split_358AA511_G_2 = _Property_85A96D15_Out_0[1];
                float _Split_358AA511_B_3 = _Property_85A96D15_Out_0[2];
                float _Split_358AA511_A_4 = _Property_85A96D15_Out_0[3];
                float3 _RotateAboutAxis_907A089F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_85A96D15_Out_0.xyz), _Split_358AA511_A_4, _RotateAboutAxis_907A089F_Out_3);
                float _Property_23C8CA7F_Out_0 = Vector1_878BB938;
                float _Multiply_864407E5_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_23C8CA7F_Out_0, _Multiply_864407E5_Out_2);
                float2 _TilingAndOffset_A1864C48_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_864407E5_Out_2.xx), _TilingAndOffset_A1864C48_Out_3);
                float _Property_37D643D8_Out_0 = Vector1_10BA39AF;
                float _GradientNoise_E0CCC673_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_A1864C48_Out_3, _Property_37D643D8_Out_0, _GradientNoise_E0CCC673_Out_2);
                float2 _TilingAndOffset_24C848AB_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_24C848AB_Out_3);
                float _GradientNoise_A84E235C_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_24C848AB_Out_3, _Property_37D643D8_Out_0, _GradientNoise_A84E235C_Out_2);
                float _Add_AEEC6F8E_Out_2;
                Unity_Add_float(_GradientNoise_E0CCC673_Out_2, _GradientNoise_A84E235C_Out_2, _Add_AEEC6F8E_Out_2);
                float _Divide_A316E786_Out_2;
                Unity_Divide_float(_Add_AEEC6F8E_Out_2, 2, _Divide_A316E786_Out_2);
                float _Saturate_1DE67959_Out_1;
                Unity_Saturate_float(_Divide_A316E786_Out_2, _Saturate_1DE67959_Out_1);
                float _Property_C7056210_Out_0 = Vector1_E01DB932;
                float _Power_9D56A5DF_Out_2;
                Unity_Power_float(_Saturate_1DE67959_Out_1, _Property_C7056210_Out_0, _Power_9D56A5DF_Out_2);
                float4 _Property_73C84E5_Out_0 = Vector4_76C337AB;
                float _Split_18B1DD64_R_1 = _Property_73C84E5_Out_0[0];
                float _Split_18B1DD64_G_2 = _Property_73C84E5_Out_0[1];
                float _Split_18B1DD64_B_3 = _Property_73C84E5_Out_0[2];
                float _Split_18B1DD64_A_4 = _Property_73C84E5_Out_0[3];
                float4 _Combine_4D21EBAF_RGBA_4;
                float3 _Combine_4D21EBAF_RGB_5;
                float2 _Combine_4D21EBAF_RG_6;
                Unity_Combine_float(_Split_18B1DD64_R_1, _Split_18B1DD64_G_2, 0, 0, _Combine_4D21EBAF_RGBA_4, _Combine_4D21EBAF_RGB_5, _Combine_4D21EBAF_RG_6);
                float4 _Combine_F4FD313C_RGBA_4;
                float3 _Combine_F4FD313C_RGB_5;
                float2 _Combine_F4FD313C_RG_6;
                Unity_Combine_float(_Split_18B1DD64_B_3, _Split_18B1DD64_A_4, 0, 0, _Combine_F4FD313C_RGBA_4, _Combine_F4FD313C_RGB_5, _Combine_F4FD313C_RG_6);
                float _Remap_94589653_Out_3;
                Unity_Remap_float(_Power_9D56A5DF_Out_2, _Combine_4D21EBAF_RG_6, _Combine_F4FD313C_RG_6, _Remap_94589653_Out_3);
                float _Absolute_C268146C_Out_1;
                Unity_Absolute_float(_Remap_94589653_Out_3, _Absolute_C268146C_Out_1);
                float _Smoothstep_F5D12A88_Out_3;
                Unity_Smoothstep_float(_Split_A93B8B1_R_1, _Split_A93B8B1_G_2, _Absolute_C268146C_Out_1, _Smoothstep_F5D12A88_Out_3);
                float _Property_1E82AAE4_Out_0 = Vector1_752EF9AE;
                float _Multiply_399758E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_1E82AAE4_Out_0, _Multiply_399758E0_Out_2);
                float2 _TilingAndOffset_517D525_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_399758E0_Out_2.xx), _TilingAndOffset_517D525_Out_3);
                float _Property_8DAC5AF3_Out_0 = Vector1_E4C3970F;
                float _GradientNoise_7487AB70_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_517D525_Out_3, _Property_8DAC5AF3_Out_0, _GradientNoise_7487AB70_Out_2);
                float _Property_F19089BF_Out_0 = Vector1_E6B27546;
                float _Multiply_E0B23D13_Out_2;
                Unity_Multiply_float(_GradientNoise_7487AB70_Out_2, _Property_F19089BF_Out_0, _Multiply_E0B23D13_Out_2);
                float _Add_AEB01DBA_Out_2;
                Unity_Add_float(_Smoothstep_F5D12A88_Out_3, _Multiply_E0B23D13_Out_2, _Add_AEB01DBA_Out_2);
                float _Add_1795A0B4_Out_2;
                Unity_Add_float(1, _Property_F19089BF_Out_0, _Add_1795A0B4_Out_2);
                float _Divide_CD48AB3B_Out_2;
                Unity_Divide_float(_Add_AEB01DBA_Out_2, _Add_1795A0B4_Out_2, _Divide_CD48AB3B_Out_2);
                float4 _Lerp_3CFA9689_Out_3;
                Unity_Lerp_float4(_Property_3267874D_Out_0, _Property_874386B5_Out_0, (_Divide_CD48AB3B_Out_2.xxxx), _Lerp_3CFA9689_Out_3);
                float _Property_B694290A_Out_0 = Vector1_3E6B7FE7;
                float _FresnelEffect_34957A66_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_B694290A_Out_0, _FresnelEffect_34957A66_Out_3);
                float _Multiply_7F434B16_Out_2;
                Unity_Multiply_float(_Divide_CD48AB3B_Out_2, _FresnelEffect_34957A66_Out_3, _Multiply_7F434B16_Out_2);
                float _Property_B24F300B_Out_0 = Vector1_39EBEC6D;
                float _Multiply_D541942D_Out_2;
                Unity_Multiply_float(_Multiply_7F434B16_Out_2, _Property_B24F300B_Out_0, _Multiply_D541942D_Out_2);
                float4 _Add_8E00908D_Out_2;
                Unity_Add_float4(_Lerp_3CFA9689_Out_3, (_Multiply_D541942D_Out_2.xxxx), _Add_8E00908D_Out_2);
                float _Property_94EB74B0_Out_0 = Vector1_2E7480A6;
                float4 _Multiply_E3794236_Out_2;
                Unity_Multiply_float(_Add_8E00908D_Out_2, (_Property_94EB74B0_Out_0.xxxx), _Multiply_E3794236_Out_2);
                float _SceneDepth_E7ABEF40_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_E7ABEF40_Out_1);
                float4 _ScreenPosition_46B36936_Out_0 = IN.ScreenPosition;
                float _Split_73EB913D_R_1 = _ScreenPosition_46B36936_Out_0[0];
                float _Split_73EB913D_G_2 = _ScreenPosition_46B36936_Out_0[1];
                float _Split_73EB913D_B_3 = _ScreenPosition_46B36936_Out_0[2];
                float _Split_73EB913D_A_4 = _ScreenPosition_46B36936_Out_0[3];
                float _Subtract_391EEEFB_Out_2;
                Unity_Subtract_float(_Split_73EB913D_A_4, 1, _Subtract_391EEEFB_Out_2);
                float _Subtract_C73106_Out_2;
                Unity_Subtract_float(_SceneDepth_E7ABEF40_Out_1, _Subtract_391EEEFB_Out_2, _Subtract_C73106_Out_2);
                float _Property_DD1B1629_Out_0 = Vector1_52AA6CA7;
                float _Divide_EA86155F_Out_2;
                Unity_Divide_float(_Subtract_C73106_Out_2, _Property_DD1B1629_Out_0, _Divide_EA86155F_Out_2);
                float _Saturate_BF09143D_Out_1;
                Unity_Saturate_float(_Divide_EA86155F_Out_2, _Saturate_BF09143D_Out_1);
                float _Smoothstep_86D32FA4_Out_3;
                Unity_Smoothstep_float(0, 1, _Saturate_BF09143D_Out_1, _Smoothstep_86D32FA4_Out_3);
                surface.Albedo = (_Add_8E00908D_Out_2.xyz);
                surface.Emission = (_Multiply_E3794236_Out_2.xyz);
                surface.Alpha = _Smoothstep_86D32FA4_Out_3;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv1 : TEXCOORD1;
                float4 uv2 : TEXCOORD2;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                float3 normalWS;
                float3 viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float3 interp02 : TEXCOORD2;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyz = input.viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.viewDirectionWS = input.interp02.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.WorldSpaceNormal =            input.normalWS;
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.WorldSpacePosition =          input.positionWS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            // Name: <None>
            Tags 
            { 
                "LightMode" = "Universal2D"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite Off
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_2D
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_B8501A8F;
            float Vector1_10BA39AF;
            float Vector1_878BB938;
            float Vector1_2E16E1AA;
            float4 Vector4_76C337AB;
            float4 Color_49648F3;
            float4 Color_FC73A812;
            float2 Vector2_E9CE62C2;
            float Vector1_E01DB932;
            float Vector1_E4C3970F;
            float Vector1_752EF9AE;
            float Vector1_E6B27546;
            float Vector1_2E7480A6;
            float Vector1_EDF9F2F0;
            float Vector1_3E6B7FE7;
            float Vector1_39EBEC6D;
            float Vector1_52AA6CA7;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_AEBF83C4_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_AEBF83C4_Out_2);
                float _Property_80F2B000_Out_0 = Vector1_EDF9F2F0;
                float _Divide_B212473D_Out_2;
                Unity_Divide_float(_Distance_AEBF83C4_Out_2, _Property_80F2B000_Out_0, _Divide_B212473D_Out_2);
                float _Power_D56B9DD9_Out_2;
                Unity_Power_float(_Divide_B212473D_Out_2, 3, _Power_D56B9DD9_Out_2);
                float3 _Multiply_ADEF0A19_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_D56B9DD9_Out_2.xxx), _Multiply_ADEF0A19_Out_2);
                float _Property_522D030F_Out_0 = Vector1_2E16E1AA;
                float2 _Property_BD0E2DDD_Out_0 = Vector2_E9CE62C2;
                float _Split_A93B8B1_R_1 = _Property_BD0E2DDD_Out_0[0];
                float _Split_A93B8B1_G_2 = _Property_BD0E2DDD_Out_0[1];
                float _Split_A93B8B1_B_3 = 0;
                float _Split_A93B8B1_A_4 = 0;
                float4 _Property_85A96D15_Out_0 = Vector4_B8501A8F;
                float _Split_358AA511_R_1 = _Property_85A96D15_Out_0[0];
                float _Split_358AA511_G_2 = _Property_85A96D15_Out_0[1];
                float _Split_358AA511_B_3 = _Property_85A96D15_Out_0[2];
                float _Split_358AA511_A_4 = _Property_85A96D15_Out_0[3];
                float3 _RotateAboutAxis_907A089F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_85A96D15_Out_0.xyz), _Split_358AA511_A_4, _RotateAboutAxis_907A089F_Out_3);
                float _Property_23C8CA7F_Out_0 = Vector1_878BB938;
                float _Multiply_864407E5_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_23C8CA7F_Out_0, _Multiply_864407E5_Out_2);
                float2 _TilingAndOffset_A1864C48_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_864407E5_Out_2.xx), _TilingAndOffset_A1864C48_Out_3);
                float _Property_37D643D8_Out_0 = Vector1_10BA39AF;
                float _GradientNoise_E0CCC673_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_A1864C48_Out_3, _Property_37D643D8_Out_0, _GradientNoise_E0CCC673_Out_2);
                float2 _TilingAndOffset_24C848AB_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_24C848AB_Out_3);
                float _GradientNoise_A84E235C_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_24C848AB_Out_3, _Property_37D643D8_Out_0, _GradientNoise_A84E235C_Out_2);
                float _Add_AEEC6F8E_Out_2;
                Unity_Add_float(_GradientNoise_E0CCC673_Out_2, _GradientNoise_A84E235C_Out_2, _Add_AEEC6F8E_Out_2);
                float _Divide_A316E786_Out_2;
                Unity_Divide_float(_Add_AEEC6F8E_Out_2, 2, _Divide_A316E786_Out_2);
                float _Saturate_1DE67959_Out_1;
                Unity_Saturate_float(_Divide_A316E786_Out_2, _Saturate_1DE67959_Out_1);
                float _Property_C7056210_Out_0 = Vector1_E01DB932;
                float _Power_9D56A5DF_Out_2;
                Unity_Power_float(_Saturate_1DE67959_Out_1, _Property_C7056210_Out_0, _Power_9D56A5DF_Out_2);
                float4 _Property_73C84E5_Out_0 = Vector4_76C337AB;
                float _Split_18B1DD64_R_1 = _Property_73C84E5_Out_0[0];
                float _Split_18B1DD64_G_2 = _Property_73C84E5_Out_0[1];
                float _Split_18B1DD64_B_3 = _Property_73C84E5_Out_0[2];
                float _Split_18B1DD64_A_4 = _Property_73C84E5_Out_0[3];
                float4 _Combine_4D21EBAF_RGBA_4;
                float3 _Combine_4D21EBAF_RGB_5;
                float2 _Combine_4D21EBAF_RG_6;
                Unity_Combine_float(_Split_18B1DD64_R_1, _Split_18B1DD64_G_2, 0, 0, _Combine_4D21EBAF_RGBA_4, _Combine_4D21EBAF_RGB_5, _Combine_4D21EBAF_RG_6);
                float4 _Combine_F4FD313C_RGBA_4;
                float3 _Combine_F4FD313C_RGB_5;
                float2 _Combine_F4FD313C_RG_6;
                Unity_Combine_float(_Split_18B1DD64_B_3, _Split_18B1DD64_A_4, 0, 0, _Combine_F4FD313C_RGBA_4, _Combine_F4FD313C_RGB_5, _Combine_F4FD313C_RG_6);
                float _Remap_94589653_Out_3;
                Unity_Remap_float(_Power_9D56A5DF_Out_2, _Combine_4D21EBAF_RG_6, _Combine_F4FD313C_RG_6, _Remap_94589653_Out_3);
                float _Absolute_C268146C_Out_1;
                Unity_Absolute_float(_Remap_94589653_Out_3, _Absolute_C268146C_Out_1);
                float _Smoothstep_F5D12A88_Out_3;
                Unity_Smoothstep_float(_Split_A93B8B1_R_1, _Split_A93B8B1_G_2, _Absolute_C268146C_Out_1, _Smoothstep_F5D12A88_Out_3);
                float _Property_1E82AAE4_Out_0 = Vector1_752EF9AE;
                float _Multiply_399758E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_1E82AAE4_Out_0, _Multiply_399758E0_Out_2);
                float2 _TilingAndOffset_517D525_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_399758E0_Out_2.xx), _TilingAndOffset_517D525_Out_3);
                float _Property_8DAC5AF3_Out_0 = Vector1_E4C3970F;
                float _GradientNoise_7487AB70_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_517D525_Out_3, _Property_8DAC5AF3_Out_0, _GradientNoise_7487AB70_Out_2);
                float _Property_F19089BF_Out_0 = Vector1_E6B27546;
                float _Multiply_E0B23D13_Out_2;
                Unity_Multiply_float(_GradientNoise_7487AB70_Out_2, _Property_F19089BF_Out_0, _Multiply_E0B23D13_Out_2);
                float _Add_AEB01DBA_Out_2;
                Unity_Add_float(_Smoothstep_F5D12A88_Out_3, _Multiply_E0B23D13_Out_2, _Add_AEB01DBA_Out_2);
                float _Add_1795A0B4_Out_2;
                Unity_Add_float(1, _Property_F19089BF_Out_0, _Add_1795A0B4_Out_2);
                float _Divide_CD48AB3B_Out_2;
                Unity_Divide_float(_Add_AEB01DBA_Out_2, _Add_1795A0B4_Out_2, _Divide_CD48AB3B_Out_2);
                float3 _Multiply_92087194_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_CD48AB3B_Out_2.xxx), _Multiply_92087194_Out_2);
                float3 _Multiply_C73EE6E6_Out_2;
                Unity_Multiply_float((_Property_522D030F_Out_0.xxx), _Multiply_92087194_Out_2, _Multiply_C73EE6E6_Out_2);
                float3 _Add_3DA86599_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_C73EE6E6_Out_2, _Add_3DA86599_Out_2);
                float3 _Add_AA4400A1_Out_2;
                Unity_Add_float3(_Multiply_ADEF0A19_Out_2, _Add_3DA86599_Out_2, _Add_AA4400A1_Out_2);
                description.VertexPosition = _Add_AA4400A1_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 TangentSpaceNormal;
                float3 WorldSpaceViewDirection;
                float3 WorldSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Albedo;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_3267874D_Out_0 = Color_49648F3;
                float4 _Property_874386B5_Out_0 = Color_FC73A812;
                float2 _Property_BD0E2DDD_Out_0 = Vector2_E9CE62C2;
                float _Split_A93B8B1_R_1 = _Property_BD0E2DDD_Out_0[0];
                float _Split_A93B8B1_G_2 = _Property_BD0E2DDD_Out_0[1];
                float _Split_A93B8B1_B_3 = 0;
                float _Split_A93B8B1_A_4 = 0;
                float4 _Property_85A96D15_Out_0 = Vector4_B8501A8F;
                float _Split_358AA511_R_1 = _Property_85A96D15_Out_0[0];
                float _Split_358AA511_G_2 = _Property_85A96D15_Out_0[1];
                float _Split_358AA511_B_3 = _Property_85A96D15_Out_0[2];
                float _Split_358AA511_A_4 = _Property_85A96D15_Out_0[3];
                float3 _RotateAboutAxis_907A089F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_85A96D15_Out_0.xyz), _Split_358AA511_A_4, _RotateAboutAxis_907A089F_Out_3);
                float _Property_23C8CA7F_Out_0 = Vector1_878BB938;
                float _Multiply_864407E5_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_23C8CA7F_Out_0, _Multiply_864407E5_Out_2);
                float2 _TilingAndOffset_A1864C48_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_864407E5_Out_2.xx), _TilingAndOffset_A1864C48_Out_3);
                float _Property_37D643D8_Out_0 = Vector1_10BA39AF;
                float _GradientNoise_E0CCC673_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_A1864C48_Out_3, _Property_37D643D8_Out_0, _GradientNoise_E0CCC673_Out_2);
                float2 _TilingAndOffset_24C848AB_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_24C848AB_Out_3);
                float _GradientNoise_A84E235C_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_24C848AB_Out_3, _Property_37D643D8_Out_0, _GradientNoise_A84E235C_Out_2);
                float _Add_AEEC6F8E_Out_2;
                Unity_Add_float(_GradientNoise_E0CCC673_Out_2, _GradientNoise_A84E235C_Out_2, _Add_AEEC6F8E_Out_2);
                float _Divide_A316E786_Out_2;
                Unity_Divide_float(_Add_AEEC6F8E_Out_2, 2, _Divide_A316E786_Out_2);
                float _Saturate_1DE67959_Out_1;
                Unity_Saturate_float(_Divide_A316E786_Out_2, _Saturate_1DE67959_Out_1);
                float _Property_C7056210_Out_0 = Vector1_E01DB932;
                float _Power_9D56A5DF_Out_2;
                Unity_Power_float(_Saturate_1DE67959_Out_1, _Property_C7056210_Out_0, _Power_9D56A5DF_Out_2);
                float4 _Property_73C84E5_Out_0 = Vector4_76C337AB;
                float _Split_18B1DD64_R_1 = _Property_73C84E5_Out_0[0];
                float _Split_18B1DD64_G_2 = _Property_73C84E5_Out_0[1];
                float _Split_18B1DD64_B_3 = _Property_73C84E5_Out_0[2];
                float _Split_18B1DD64_A_4 = _Property_73C84E5_Out_0[3];
                float4 _Combine_4D21EBAF_RGBA_4;
                float3 _Combine_4D21EBAF_RGB_5;
                float2 _Combine_4D21EBAF_RG_6;
                Unity_Combine_float(_Split_18B1DD64_R_1, _Split_18B1DD64_G_2, 0, 0, _Combine_4D21EBAF_RGBA_4, _Combine_4D21EBAF_RGB_5, _Combine_4D21EBAF_RG_6);
                float4 _Combine_F4FD313C_RGBA_4;
                float3 _Combine_F4FD313C_RGB_5;
                float2 _Combine_F4FD313C_RG_6;
                Unity_Combine_float(_Split_18B1DD64_B_3, _Split_18B1DD64_A_4, 0, 0, _Combine_F4FD313C_RGBA_4, _Combine_F4FD313C_RGB_5, _Combine_F4FD313C_RG_6);
                float _Remap_94589653_Out_3;
                Unity_Remap_float(_Power_9D56A5DF_Out_2, _Combine_4D21EBAF_RG_6, _Combine_F4FD313C_RG_6, _Remap_94589653_Out_3);
                float _Absolute_C268146C_Out_1;
                Unity_Absolute_float(_Remap_94589653_Out_3, _Absolute_C268146C_Out_1);
                float _Smoothstep_F5D12A88_Out_3;
                Unity_Smoothstep_float(_Split_A93B8B1_R_1, _Split_A93B8B1_G_2, _Absolute_C268146C_Out_1, _Smoothstep_F5D12A88_Out_3);
                float _Property_1E82AAE4_Out_0 = Vector1_752EF9AE;
                float _Multiply_399758E0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_1E82AAE4_Out_0, _Multiply_399758E0_Out_2);
                float2 _TilingAndOffset_517D525_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_907A089F_Out_3.xy), float2 (1, 1), (_Multiply_399758E0_Out_2.xx), _TilingAndOffset_517D525_Out_3);
                float _Property_8DAC5AF3_Out_0 = Vector1_E4C3970F;
                float _GradientNoise_7487AB70_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_517D525_Out_3, _Property_8DAC5AF3_Out_0, _GradientNoise_7487AB70_Out_2);
                float _Property_F19089BF_Out_0 = Vector1_E6B27546;
                float _Multiply_E0B23D13_Out_2;
                Unity_Multiply_float(_GradientNoise_7487AB70_Out_2, _Property_F19089BF_Out_0, _Multiply_E0B23D13_Out_2);
                float _Add_AEB01DBA_Out_2;
                Unity_Add_float(_Smoothstep_F5D12A88_Out_3, _Multiply_E0B23D13_Out_2, _Add_AEB01DBA_Out_2);
                float _Add_1795A0B4_Out_2;
                Unity_Add_float(1, _Property_F19089BF_Out_0, _Add_1795A0B4_Out_2);
                float _Divide_CD48AB3B_Out_2;
                Unity_Divide_float(_Add_AEB01DBA_Out_2, _Add_1795A0B4_Out_2, _Divide_CD48AB3B_Out_2);
                float4 _Lerp_3CFA9689_Out_3;
                Unity_Lerp_float4(_Property_3267874D_Out_0, _Property_874386B5_Out_0, (_Divide_CD48AB3B_Out_2.xxxx), _Lerp_3CFA9689_Out_3);
                float _Property_B694290A_Out_0 = Vector1_3E6B7FE7;
                float _FresnelEffect_34957A66_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_B694290A_Out_0, _FresnelEffect_34957A66_Out_3);
                float _Multiply_7F434B16_Out_2;
                Unity_Multiply_float(_Divide_CD48AB3B_Out_2, _FresnelEffect_34957A66_Out_3, _Multiply_7F434B16_Out_2);
                float _Property_B24F300B_Out_0 = Vector1_39EBEC6D;
                float _Multiply_D541942D_Out_2;
                Unity_Multiply_float(_Multiply_7F434B16_Out_2, _Property_B24F300B_Out_0, _Multiply_D541942D_Out_2);
                float4 _Add_8E00908D_Out_2;
                Unity_Add_float4(_Lerp_3CFA9689_Out_3, (_Multiply_D541942D_Out_2.xxxx), _Add_8E00908D_Out_2);
                float _SceneDepth_E7ABEF40_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_E7ABEF40_Out_1);
                float4 _ScreenPosition_46B36936_Out_0 = IN.ScreenPosition;
                float _Split_73EB913D_R_1 = _ScreenPosition_46B36936_Out_0[0];
                float _Split_73EB913D_G_2 = _ScreenPosition_46B36936_Out_0[1];
                float _Split_73EB913D_B_3 = _ScreenPosition_46B36936_Out_0[2];
                float _Split_73EB913D_A_4 = _ScreenPosition_46B36936_Out_0[3];
                float _Subtract_391EEEFB_Out_2;
                Unity_Subtract_float(_Split_73EB913D_A_4, 1, _Subtract_391EEEFB_Out_2);
                float _Subtract_C73106_Out_2;
                Unity_Subtract_float(_SceneDepth_E7ABEF40_Out_1, _Subtract_391EEEFB_Out_2, _Subtract_C73106_Out_2);
                float _Property_DD1B1629_Out_0 = Vector1_52AA6CA7;
                float _Divide_EA86155F_Out_2;
                Unity_Divide_float(_Subtract_C73106_Out_2, _Property_DD1B1629_Out_0, _Divide_EA86155F_Out_2);
                float _Saturate_BF09143D_Out_1;
                Unity_Saturate_float(_Divide_EA86155F_Out_2, _Saturate_BF09143D_Out_1);
                float _Smoothstep_86D32FA4_Out_3;
                Unity_Smoothstep_float(0, 1, _Saturate_BF09143D_Out_1, _Smoothstep_86D32FA4_Out_3);
                surface.Albedo = (_Add_8E00908D_Out_2.xyz);
                surface.Alpha = _Smoothstep_86D32FA4_Out_3;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                float3 normalWS;
                float3 viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float3 interp02 : TEXCOORD2;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyz = input.viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.viewDirectionWS = input.interp02.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.WorldSpaceNormal =            input.normalWS;
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.WorldSpacePosition =          input.positionWS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
            ENDHLSL
        }
        
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
