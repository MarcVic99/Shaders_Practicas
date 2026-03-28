Shader "Shader Graphs/VertexPaint"
{
    Properties
    {
        _Uv_Scales("Uv Scales", Float) = 1
        [NoScaleOffset]_A_Abledo("A - Abledo", 2D) = "white" {}
        [NoScaleOffset]_B_Albedo("B - Albedo", 2D) = "white" {}
        [Normal][NoScaleOffset]_A_Normal("A - Normal", 2D) = "bump" {}
        [Normal][NoScaleOffset]_B_Normal("B - Normal", 2D) = "bump" {}
        [NoScaleOffset]_A_MAOHS("A - MAOHS", 2D) = "white" {}
        [NoScaleOffset]_B_MAOHS("B - MAOHS", 2D) = "white" {}
        _NoiseScale("NoiseScale", Float) = 10
        _Blend_Distance("Blend Distance", Float) = 0.1
        _Snow_Metallic("Snow Metallic", Float) = 0
        _Snow_Smoothness("Snow Smoothness", Float) = 0.02
        _Snow_AO("Snow AO", Float) = 0
        _Vertical_Displacement("Vertical Displacement", Float) = 50
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 color : INTERP7;
             float4 fogFactorAndVertexLight : INTERP8;
             float3 positionWS : INTERP9;
             float3 normalWS : INTERP10;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Smoothstep_float4(float4 Edge1, float4 Edge2, float4 In, out float4 Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Overwrite_float(float Base, float Blend, out float Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_Abledo);
            float4 _UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4 = IN.uv0;
            float _Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float = _Uv_Scales;
            float4 _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4, (_Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float.xxxx), _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4);
            float4 _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.tex, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.samplerstate, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_R_4_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.r;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_G_5_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.g;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_B_6_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.b;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_A_7_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.a;
            UnityTexture2D _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_Albedo);
            float4 _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.tex, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.samplerstate, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_R_4_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.r;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_G_5_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.g;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_B_6_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.b;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_A_7_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.a;
            float4 _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4;
            Unity_OneMinus_float4(IN.VertexColor, _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4);
            float _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float = _Blend_Distance;
            float _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float;
            Unity_Subtract_float(float(0), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float);
            float _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float;
            Unity_Add_float(float(1), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float2 _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2 = float2(_Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float4 _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4;
            Unity_Remap_float4(_OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4, float2 (0, 1), _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2, _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4);
            float _Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float = _Blend_Distance;
            float4 _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4;
            Unity_Subtract_float4(_Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, (_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4);
            float4 _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4;
            Unity_Add_float4((_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4);
            float _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float = _NoiseScale;
            float _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float, _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float);
            float4 _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4;
            Unity_Smoothstep_float4(_Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4, (_GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float.xxxx), _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4);
            float _Split_ae4094a08c7a4884988dda037557aced_R_1_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[0];
            float _Split_ae4094a08c7a4884988dda037557aced_G_2_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[1];
            float _Split_ae4094a08c7a4884988dda037557aced_B_3_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[2];
            float _Split_ae4094a08c7a4884988dda037557aced_A_4_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[3];
            float4 _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4, _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4, _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float4 _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4;
            Unity_Lerp_float4(_Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, float4(1, 1, 1, 1), (_Split_ae4094a08c7a4884988dda037557aced_G_2_Float.xxxx), _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4);
            UnityTexture2D _Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_Normal);
            float4 _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D.tex, _Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D.samplerstate, _Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4);
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_R_4_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.r;
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_G_5_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.g;
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_B_6_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.b;
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_A_7_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.a;
            UnityTexture2D _Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_Normal);
            float4 _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D.tex, _Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D.samplerstate, _Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4);
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_R_4_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.r;
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_G_5_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.g;
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_B_6_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.b;
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_A_7_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.a;
            float _Saturate_c1011632a6eb441fb423b399a6e80b36_Out_1_Float;
            Unity_Saturate_float(_Split_ae4094a08c7a4884988dda037557aced_R_1_Float, _Saturate_c1011632a6eb441fb423b399a6e80b36_Out_1_Float);
            float4 _Lerp_cf42c8c8dabc4eff8dff546063fb7a55_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4, _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4, (_Saturate_c1011632a6eb441fb423b399a6e80b36_Out_1_Float.xxxx), _Lerp_cf42c8c8dabc4eff8dff546063fb7a55_Out_3_Vector4);
            UnityTexture2D _Property_779a896331c947b2812b8d68773e947d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_MAOHS);
            float4 _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_779a896331c947b2812b8d68773e947d_Out_0_Texture2D.tex, _Property_779a896331c947b2812b8d68773e947d_Out_0_Texture2D.samplerstate, _Property_779a896331c947b2812b8d68773e947d_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_R_4_Float = _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4.r;
            float _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_G_5_Float = _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4.g;
            float _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_B_6_Float = _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4.b;
            float _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_A_7_Float = _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4.a;
            UnityTexture2D _Property_54298c45e2c4416f8dbecdef47183091_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_MAOHS);
            float4 _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_54298c45e2c4416f8dbecdef47183091_Out_0_Texture2D.tex, _Property_54298c45e2c4416f8dbecdef47183091_Out_0_Texture2D.samplerstate, _Property_54298c45e2c4416f8dbecdef47183091_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_R_4_Float = _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4.r;
            float _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_G_5_Float = _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4.g;
            float _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_B_6_Float = _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4.b;
            float _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_A_7_Float = _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4.a;
            float _Blend_2ec3500598704d058dde2e7b071e27ec_Out_2_Float;
            Unity_Blend_Overwrite_float(_SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_R_4_Float, _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_R_4_Float, _Blend_2ec3500598704d058dde2e7b071e27ec_Out_2_Float, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float _Property_3b91ce158d554681a962b70cfbca98e6_Out_0_Float = _Snow_Metallic;
            float _Lerp_0cc8e3524b5d43b395a7ab1ccf2875fe_Out_3_Float;
            Unity_Lerp_float(_Blend_2ec3500598704d058dde2e7b071e27ec_Out_2_Float, _Property_3b91ce158d554681a962b70cfbca98e6_Out_0_Float, _Split_ae4094a08c7a4884988dda037557aced_G_2_Float, _Lerp_0cc8e3524b5d43b395a7ab1ccf2875fe_Out_3_Float);
            float _Blend_2e0d995acc56493e984834ad79a4ebe2_Out_2_Float;
            Unity_Blend_Overwrite_float(_SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_A_7_Float, _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_A_7_Float, _Blend_2e0d995acc56493e984834ad79a4ebe2_Out_2_Float, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float _Property_8846e1c94b2d4b96ac2dcba6a4cb8fa2_Out_0_Float = _Snow_Smoothness;
            float _Lerp_2f0b1691b1634ea1983e8249d5017549_Out_3_Float;
            Unity_Lerp_float(_Blend_2e0d995acc56493e984834ad79a4ebe2_Out_2_Float, _Property_8846e1c94b2d4b96ac2dcba6a4cb8fa2_Out_0_Float, _Split_ae4094a08c7a4884988dda037557aced_G_2_Float, _Lerp_2f0b1691b1634ea1983e8249d5017549_Out_3_Float);
            float _Blend_3321046abd5747a8988f7aa199bfee53_Out_2_Float;
            Unity_Blend_Overwrite_float(_SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_G_5_Float, _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_G_5_Float, _Blend_3321046abd5747a8988f7aa199bfee53_Out_2_Float, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float _Property_01202c068647453ab473f61f0e85a253_Out_0_Float = _Snow_AO;
            float _Lerp_22a1f4d206fc4342bc4f605b4c0ff0f0_Out_3_Float;
            Unity_Lerp_float(_Blend_3321046abd5747a8988f7aa199bfee53_Out_2_Float, _Property_01202c068647453ab473f61f0e85a253_Out_0_Float, _Split_ae4094a08c7a4884988dda037557aced_G_2_Float, _Lerp_22a1f4d206fc4342bc4f605b4c0ff0f0_Out_3_Float);
            surface.BaseColor = (_Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4.xyz);
            surface.NormalTS = (_Lerp_cf42c8c8dabc4eff8dff546063fb7a55_Out_3_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Lerp_0cc8e3524b5d43b395a7ab1ccf2875fe_Out_3_Float;
            surface.Smoothness = _Lerp_2f0b1691b1634ea1983e8249d5017549_Out_3_Float;
            surface.Occlusion = _Lerp_22a1f4d206fc4342bc4f605b4c0ff0f0_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 color : INTERP7;
             float4 fogFactorAndVertexLight : INTERP8;
             float3 positionWS : INTERP9;
             float3 normalWS : INTERP10;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Smoothstep_float4(float4 Edge1, float4 Edge2, float4 In, out float4 Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Overwrite_float(float Base, float Blend, out float Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_Abledo);
            float4 _UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4 = IN.uv0;
            float _Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float = _Uv_Scales;
            float4 _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4, (_Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float.xxxx), _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4);
            float4 _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.tex, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.samplerstate, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_R_4_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.r;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_G_5_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.g;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_B_6_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.b;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_A_7_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.a;
            UnityTexture2D _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_Albedo);
            float4 _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.tex, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.samplerstate, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_R_4_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.r;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_G_5_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.g;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_B_6_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.b;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_A_7_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.a;
            float4 _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4;
            Unity_OneMinus_float4(IN.VertexColor, _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4);
            float _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float = _Blend_Distance;
            float _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float;
            Unity_Subtract_float(float(0), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float);
            float _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float;
            Unity_Add_float(float(1), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float2 _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2 = float2(_Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float4 _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4;
            Unity_Remap_float4(_OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4, float2 (0, 1), _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2, _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4);
            float _Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float = _Blend_Distance;
            float4 _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4;
            Unity_Subtract_float4(_Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, (_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4);
            float4 _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4;
            Unity_Add_float4((_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4);
            float _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float = _NoiseScale;
            float _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float, _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float);
            float4 _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4;
            Unity_Smoothstep_float4(_Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4, (_GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float.xxxx), _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4);
            float _Split_ae4094a08c7a4884988dda037557aced_R_1_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[0];
            float _Split_ae4094a08c7a4884988dda037557aced_G_2_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[1];
            float _Split_ae4094a08c7a4884988dda037557aced_B_3_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[2];
            float _Split_ae4094a08c7a4884988dda037557aced_A_4_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[3];
            float4 _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4, _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4, _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float4 _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4;
            Unity_Lerp_float4(_Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, float4(1, 1, 1, 1), (_Split_ae4094a08c7a4884988dda037557aced_G_2_Float.xxxx), _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4);
            UnityTexture2D _Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_Normal);
            float4 _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D.tex, _Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D.samplerstate, _Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4);
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_R_4_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.r;
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_G_5_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.g;
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_B_6_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.b;
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_A_7_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.a;
            UnityTexture2D _Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_Normal);
            float4 _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D.tex, _Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D.samplerstate, _Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4);
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_R_4_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.r;
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_G_5_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.g;
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_B_6_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.b;
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_A_7_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.a;
            float _Saturate_c1011632a6eb441fb423b399a6e80b36_Out_1_Float;
            Unity_Saturate_float(_Split_ae4094a08c7a4884988dda037557aced_R_1_Float, _Saturate_c1011632a6eb441fb423b399a6e80b36_Out_1_Float);
            float4 _Lerp_cf42c8c8dabc4eff8dff546063fb7a55_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4, _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4, (_Saturate_c1011632a6eb441fb423b399a6e80b36_Out_1_Float.xxxx), _Lerp_cf42c8c8dabc4eff8dff546063fb7a55_Out_3_Vector4);
            UnityTexture2D _Property_779a896331c947b2812b8d68773e947d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_MAOHS);
            float4 _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_779a896331c947b2812b8d68773e947d_Out_0_Texture2D.tex, _Property_779a896331c947b2812b8d68773e947d_Out_0_Texture2D.samplerstate, _Property_779a896331c947b2812b8d68773e947d_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_R_4_Float = _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4.r;
            float _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_G_5_Float = _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4.g;
            float _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_B_6_Float = _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4.b;
            float _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_A_7_Float = _SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_RGBA_0_Vector4.a;
            UnityTexture2D _Property_54298c45e2c4416f8dbecdef47183091_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_MAOHS);
            float4 _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_54298c45e2c4416f8dbecdef47183091_Out_0_Texture2D.tex, _Property_54298c45e2c4416f8dbecdef47183091_Out_0_Texture2D.samplerstate, _Property_54298c45e2c4416f8dbecdef47183091_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_R_4_Float = _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4.r;
            float _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_G_5_Float = _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4.g;
            float _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_B_6_Float = _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4.b;
            float _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_A_7_Float = _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_RGBA_0_Vector4.a;
            float _Blend_2ec3500598704d058dde2e7b071e27ec_Out_2_Float;
            Unity_Blend_Overwrite_float(_SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_R_4_Float, _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_R_4_Float, _Blend_2ec3500598704d058dde2e7b071e27ec_Out_2_Float, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float _Property_3b91ce158d554681a962b70cfbca98e6_Out_0_Float = _Snow_Metallic;
            float _Lerp_0cc8e3524b5d43b395a7ab1ccf2875fe_Out_3_Float;
            Unity_Lerp_float(_Blend_2ec3500598704d058dde2e7b071e27ec_Out_2_Float, _Property_3b91ce158d554681a962b70cfbca98e6_Out_0_Float, _Split_ae4094a08c7a4884988dda037557aced_G_2_Float, _Lerp_0cc8e3524b5d43b395a7ab1ccf2875fe_Out_3_Float);
            float _Blend_2e0d995acc56493e984834ad79a4ebe2_Out_2_Float;
            Unity_Blend_Overwrite_float(_SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_A_7_Float, _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_A_7_Float, _Blend_2e0d995acc56493e984834ad79a4ebe2_Out_2_Float, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float _Property_8846e1c94b2d4b96ac2dcba6a4cb8fa2_Out_0_Float = _Snow_Smoothness;
            float _Lerp_2f0b1691b1634ea1983e8249d5017549_Out_3_Float;
            Unity_Lerp_float(_Blend_2e0d995acc56493e984834ad79a4ebe2_Out_2_Float, _Property_8846e1c94b2d4b96ac2dcba6a4cb8fa2_Out_0_Float, _Split_ae4094a08c7a4884988dda037557aced_G_2_Float, _Lerp_2f0b1691b1634ea1983e8249d5017549_Out_3_Float);
            float _Blend_3321046abd5747a8988f7aa199bfee53_Out_2_Float;
            Unity_Blend_Overwrite_float(_SampleTexture2D_3f9bc11d92de41c999a0dd900ff73f5a_G_5_Float, _SampleTexture2D_ac22e308085f432b87fcd2c35ce21f2a_G_5_Float, _Blend_3321046abd5747a8988f7aa199bfee53_Out_2_Float, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float _Property_01202c068647453ab473f61f0e85a253_Out_0_Float = _Snow_AO;
            float _Lerp_22a1f4d206fc4342bc4f605b4c0ff0f0_Out_3_Float;
            Unity_Lerp_float(_Blend_3321046abd5747a8988f7aa199bfee53_Out_2_Float, _Property_01202c068647453ab473f61f0e85a253_Out_0_Float, _Split_ae4094a08c7a4884988dda037557aced_G_2_Float, _Lerp_22a1f4d206fc4342bc4f605b4c0ff0f0_Out_3_Float);
            surface.BaseColor = (_Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4.xyz);
            surface.NormalTS = (_Lerp_cf42c8c8dabc4eff8dff546063fb7a55_Out_3_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Lerp_0cc8e3524b5d43b395a7ab1ccf2875fe_Out_3_Float;
            surface.Smoothness = _Lerp_2f0b1691b1634ea1983e8249d5017549_Out_3_Float;
            surface.Occlusion = _Lerp_22a1f4d206fc4342bc4f605b4c0ff0f0_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
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
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
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
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 color : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Smoothstep_float4(float4 Edge1, float4 Edge2, float4 In, out float4 Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_Normal);
            float4 _UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4 = IN.uv0;
            float _Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float = _Uv_Scales;
            float4 _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4, (_Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float.xxxx), _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4);
            float4 _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D.tex, _Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D.samplerstate, _Property_7c22a29a6d2c483cb1b679648d061031_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4);
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_R_4_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.r;
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_G_5_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.g;
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_B_6_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.b;
            float _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_A_7_Float = _SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4.a;
            UnityTexture2D _Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_Normal);
            float4 _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D.tex, _Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D.samplerstate, _Property_52519d18dbe54777bef0385b83acd40e_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4);
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_R_4_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.r;
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_G_5_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.g;
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_B_6_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.b;
            float _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_A_7_Float = _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4.a;
            float4 _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4;
            Unity_OneMinus_float4(IN.VertexColor, _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4);
            float _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float = _Blend_Distance;
            float _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float;
            Unity_Subtract_float(float(0), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float);
            float _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float;
            Unity_Add_float(float(1), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float2 _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2 = float2(_Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float4 _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4;
            Unity_Remap_float4(_OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4, float2 (0, 1), _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2, _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4);
            float _Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float = _Blend_Distance;
            float4 _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4;
            Unity_Subtract_float4(_Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, (_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4);
            float4 _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4;
            Unity_Add_float4((_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4);
            float _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float = _NoiseScale;
            float _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float, _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float);
            float4 _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4;
            Unity_Smoothstep_float4(_Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4, (_GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float.xxxx), _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4);
            float _Split_ae4094a08c7a4884988dda037557aced_R_1_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[0];
            float _Split_ae4094a08c7a4884988dda037557aced_G_2_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[1];
            float _Split_ae4094a08c7a4884988dda037557aced_B_3_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[2];
            float _Split_ae4094a08c7a4884988dda037557aced_A_4_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[3];
            float _Saturate_c1011632a6eb441fb423b399a6e80b36_Out_1_Float;
            Unity_Saturate_float(_Split_ae4094a08c7a4884988dda037557aced_R_1_Float, _Saturate_c1011632a6eb441fb423b399a6e80b36_Out_1_Float);
            float4 _Lerp_cf42c8c8dabc4eff8dff546063fb7a55_Out_3_Vector4;
            Unity_Lerp_float4(_SampleTexture2D_5ca3a255cbdc4a74ba6bd9e34fe063a2_RGBA_0_Vector4, _SampleTexture2D_435e8ee5065246ab91d0b4407e65da1f_RGBA_0_Vector4, (_Saturate_c1011632a6eb441fb423b399a6e80b36_Out_1_Float.xxxx), _Lerp_cf42c8c8dabc4eff8dff546063fb7a55_Out_3_Vector4);
            surface.NormalTS = (_Lerp_cf42c8c8dabc4eff8dff546063fb7a55_Out_3_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
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
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_COLOR
        #define ATTRIBUTES_NEED_INSTANCEID
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float4 color : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Smoothstep_float4(float4 Edge1, float4 Edge2, float4 In, out float4 Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_Abledo);
            float4 _UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4 = IN.uv0;
            float _Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float = _Uv_Scales;
            float4 _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4, (_Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float.xxxx), _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4);
            float4 _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.tex, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.samplerstate, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_R_4_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.r;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_G_5_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.g;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_B_6_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.b;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_A_7_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.a;
            UnityTexture2D _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_Albedo);
            float4 _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.tex, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.samplerstate, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_R_4_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.r;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_G_5_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.g;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_B_6_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.b;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_A_7_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.a;
            float4 _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4;
            Unity_OneMinus_float4(IN.VertexColor, _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4);
            float _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float = _Blend_Distance;
            float _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float;
            Unity_Subtract_float(float(0), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float);
            float _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float;
            Unity_Add_float(float(1), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float2 _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2 = float2(_Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float4 _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4;
            Unity_Remap_float4(_OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4, float2 (0, 1), _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2, _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4);
            float _Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float = _Blend_Distance;
            float4 _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4;
            Unity_Subtract_float4(_Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, (_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4);
            float4 _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4;
            Unity_Add_float4((_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4);
            float _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float = _NoiseScale;
            float _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float, _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float);
            float4 _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4;
            Unity_Smoothstep_float4(_Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4, (_GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float.xxxx), _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4);
            float _Split_ae4094a08c7a4884988dda037557aced_R_1_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[0];
            float _Split_ae4094a08c7a4884988dda037557aced_G_2_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[1];
            float _Split_ae4094a08c7a4884988dda037557aced_B_3_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[2];
            float _Split_ae4094a08c7a4884988dda037557aced_A_4_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[3];
            float4 _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4, _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4, _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float4 _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4;
            Unity_Lerp_float4(_Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, float4(1, 1, 1, 1), (_Split_ae4094a08c7a4884988dda037557aced_G_2_Float.xxxx), _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4);
            surface.BaseColor = (_Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Smoothstep_float4(float4 Edge1, float4 Edge2, float4 In, out float4 Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_Abledo);
            float4 _UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4 = IN.uv0;
            float _Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float = _Uv_Scales;
            float4 _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4, (_Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float.xxxx), _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4);
            float4 _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.tex, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.samplerstate, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_R_4_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.r;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_G_5_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.g;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_B_6_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.b;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_A_7_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.a;
            UnityTexture2D _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_Albedo);
            float4 _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.tex, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.samplerstate, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_R_4_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.r;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_G_5_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.g;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_B_6_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.b;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_A_7_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.a;
            float4 _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4;
            Unity_OneMinus_float4(IN.VertexColor, _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4);
            float _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float = _Blend_Distance;
            float _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float;
            Unity_Subtract_float(float(0), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float);
            float _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float;
            Unity_Add_float(float(1), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float2 _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2 = float2(_Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float4 _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4;
            Unity_Remap_float4(_OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4, float2 (0, 1), _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2, _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4);
            float _Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float = _Blend_Distance;
            float4 _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4;
            Unity_Subtract_float4(_Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, (_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4);
            float4 _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4;
            Unity_Add_float4((_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4);
            float _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float = _NoiseScale;
            float _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float, _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float);
            float4 _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4;
            Unity_Smoothstep_float4(_Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4, (_GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float.xxxx), _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4);
            float _Split_ae4094a08c7a4884988dda037557aced_R_1_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[0];
            float _Split_ae4094a08c7a4884988dda037557aced_G_2_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[1];
            float _Split_ae4094a08c7a4884988dda037557aced_B_3_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[2];
            float _Split_ae4094a08c7a4884988dda037557aced_A_4_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[3];
            float4 _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4, _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4, _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float4 _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4;
            Unity_Lerp_float4(_Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, float4(1, 1, 1, 1), (_Split_ae4094a08c7a4884988dda037557aced_G_2_Float.xxxx), _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4);
            surface.BaseColor = (_Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _NoiseScale;
        float _Blend_Distance;
        float4 _B_Albedo_TexelSize;
        float4 _A_Normal_TexelSize;
        float4 _B_Normal_TexelSize;
        float4 _A_MAOHS_TexelSize;
        float4 _B_MAOHS_TexelSize;
        float4 _A_Abledo_TexelSize;
        float _Uv_Scales;
        float _Snow_Metallic;
        float _Snow_Smoothness;
        float _Snow_AO;
        float _Vertical_Displacement;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_B_Albedo);
        SAMPLER(sampler_B_Albedo);
        TEXTURE2D(_A_Normal);
        SAMPLER(sampler_A_Normal);
        TEXTURE2D(_B_Normal);
        SAMPLER(sampler_B_Normal);
        TEXTURE2D(_A_MAOHS);
        SAMPLER(sampler_A_MAOHS);
        TEXTURE2D(_B_MAOHS);
        SAMPLER(sampler_B_MAOHS);
        TEXTURE2D(_A_Abledo);
        SAMPLER(sampler_A_Abledo);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Smoothstep_float4(float4 Edge1, float4 Edge2, float4 In, out float4 Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Blend_Overwrite_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = lerp(Base, Blend, Opacity);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_859b1dbc367a4f74bce9173ac475015c_R_1_Float = IN.VertexColor[0];
            float _Split_859b1dbc367a4f74bce9173ac475015c_G_2_Float = IN.VertexColor[1];
            float _Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float = IN.VertexColor[2];
            float _Split_859b1dbc367a4f74bce9173ac475015c_A_4_Float = IN.VertexColor[3];
            float _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float = _Vertical_Displacement;
            float _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float;
            Unity_Multiply_float_float(_Split_859b1dbc367a4f74bce9173ac475015c_B_3_Float, _Property_40061d0eb99447f58f79b941ae2a56fa_Out_0_Float, _Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float);
            float3 _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float3 _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Multiply_d71181f981814f6ba768bf7dcfddafce_Out_2_Float.xxx), _Vector3_ababb5e7e82d472ab22dfe17a89adcb6_Out_0_Vector3, _Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3);
            float3 _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            Unity_Add_float3(_Multiply_d6655633ad864cf1ac942c44f0bc4a85_Out_2_Vector3, IN.ObjectSpacePosition, _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3);
            description.Position = _Add_2235e3d3ff364765ac09e2f8ffe5592f_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_A_Abledo);
            float4 _UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4 = IN.uv0;
            float _Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float = _Uv_Scales;
            float4 _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_8583d7326c7b4dc782646b06880bb51a_Out_0_Vector4, (_Property_1593a2853bf94119b3035bfd39597c35_Out_0_Float.xxxx), _Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4);
            float4 _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.tex, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.samplerstate, _Property_a9f5ab45c515443aa649207f806a36e8_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_R_4_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.r;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_G_5_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.g;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_B_6_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.b;
            float _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_A_7_Float = _SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4.a;
            UnityTexture2D _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_B_Albedo);
            float4 _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.tex, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.samplerstate, _Property_e5552a561a854f719557477fcc3da361_Out_0_Texture2D.GetTransformedUV((_Multiply_ca5ad203892b485b96a3d26c8057a82b_Out_2_Vector4.xy)) );
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_R_4_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.r;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_G_5_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.g;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_B_6_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.b;
            float _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_A_7_Float = _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4.a;
            float4 _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4;
            Unity_OneMinus_float4(IN.VertexColor, _OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4);
            float _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float = _Blend_Distance;
            float _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float;
            Unity_Subtract_float(float(0), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float);
            float _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float;
            Unity_Add_float(float(1), _Property_73a2dde842d44059985d1c59d01365e0_Out_0_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float2 _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2 = float2(_Subtract_c5436744ef7c4646bb09a4e031e217ca_Out_2_Float, _Add_d4ee30b2bf0142839139eb0cc84f700f_Out_2_Float);
            float4 _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4;
            Unity_Remap_float4(_OneMinus_c10cb8212b284a999c05f247031be665_Out_1_Vector4, float2 (0, 1), _Vector2_8655159e4eb041439fcd342d8621d580_Out_0_Vector2, _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4);
            float _Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float = _Blend_Distance;
            float4 _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4;
            Unity_Subtract_float4(_Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, (_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4);
            float4 _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4;
            Unity_Add_float4((_Property_221fd0cfaed74d1788886486cf6f325d_Out_0_Float.xxxx), _Remap_11df0793e2994a96bada6ecd911529ec_Out_3_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4);
            float _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float = _NoiseScale;
            float _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(IN.uv0.xy, _Property_fbef605e6f4d44beb1ac93be53bc40a9_Out_0_Float, _GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float);
            float4 _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4;
            Unity_Smoothstep_float4(_Subtract_2295b8c47dad4fde8c1796a850e8ebab_Out_2_Vector4, _Add_15f8971734a7417a886b3c751cc43620_Out_2_Vector4, (_GradientNoise_e5696722191b4ffd9e745ad297fffc9e_Out_2_Float.xxxx), _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4);
            float _Split_ae4094a08c7a4884988dda037557aced_R_1_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[0];
            float _Split_ae4094a08c7a4884988dda037557aced_G_2_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[1];
            float _Split_ae4094a08c7a4884988dda037557aced_B_3_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[2];
            float _Split_ae4094a08c7a4884988dda037557aced_A_4_Float = _Smoothstep_118b8a5a3b7f4331aeb3fc15caf798fc_Out_3_Vector4[3];
            float4 _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4;
            Unity_Blend_Overwrite_float4(_SampleTexture2D_774c041021754ebaaff25a6aac6aee6b_RGBA_0_Vector4, _SampleTexture2D_15ecf7ff13b7484bb7dcd8dc182def85_RGBA_0_Vector4, _Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, _Split_ae4094a08c7a4884988dda037557aced_R_1_Float);
            float4 _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4;
            Unity_Lerp_float4(_Blend_57e87c6e163d40e4abfe367ec6d754e8_Out_2_Vector4, float4(1, 1, 1, 1), (_Split_ae4094a08c7a4884988dda037557aced_G_2_Float.xxxx), _Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4);
            surface.BaseColor = (_Lerp_e0a2f322b1dc468bba83cd4ec90d688c_Out_3_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
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
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}