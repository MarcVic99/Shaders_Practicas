Shader "Shader Graphs/Barrier"
{
    Properties
    {
        _UV_Tile("UV Tile", Vector, 2) = (5, 5, 0, 0)
        [HDR]_Color("Color", Color) = (0, 0.952589, 1, 1)
        _Time_Speed("Time Speed", Float) = 1
        _Hex_Strength("Hex Strength", Float) = 2
        _Interior_Intensity("Interior Intensity", Float) = 1
        _Edge_Intensity("Edge Intensity", Float) = 1
        _Edge_Center_Opacity_Contrast("Edge Center Opacity Contrast", Float) = 2
        _Edge_Border_Opacity_Contrast("Edge Border Opacity Contrast", Float) = 5
        _Edge_Border_Opacity_Intensity("Edge Border Opacity Intensity", Float) = 1.5
        _Depth_Detection_Distance("Depth Detection Distance", Float) = 50
        _Depth_Detection_Constrast("Depth Detection Constrast", Float) = 2
        _Depth_Detection_Interior_Intensity("Depth Detection Interior Intensity", Float) = 0.4
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
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
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
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
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
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
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
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
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
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
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
        float _Hex_Strength;
        float4 _Color;
        float _Interior_Intensity;
        float _Edge_Intensity;
        float _Time_Speed;
        float2 _UV_Tile;
        float _Edge_Border_Opacity_Contrast;
        float _Edge_Center_Opacity_Contrast;
        float _Edge_Border_Opacity_Intensity;
        float _Depth_Detection_Distance;
        float _Depth_Detection_Constrast;
        float _Depth_Detection_Interior_Intensity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        // unity-custom-func-begin
        void GetHexId_float(float2 p, float2 hexSize, out float4 result){
            float4 h = float4(p, p - hexSize/2.0);
            float4 iC = floor(h/hexSize.xyxy) + 0.5;
            h -= iC*hexSize.xyxy;
            result = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? float4(h.xy, iC.xy) : float4(h.zw, iC.zw + .5);
        }
        // unity-custom-func-end
        
        void Unity_ChannelMask_RedGreen_float4 (float4 In, out float4 Out)
        {
            Out = float4(In.r, In.g, 0, 0);
        }
        
        void Unity_DotProduct_float4(float4 A, float4 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
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
            description.Position = IN.ObjectSpacePosition;
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4 = IN.uv0;
            float2 _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2 = _UV_Tile;
            float2 _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4.xy), _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2, _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2);
            float _Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float = _Time_Speed;
            float _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float, IN.TimeParameters.x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float);
            float2 _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2 = float2( float(0).x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float.x );
            float2 _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2, _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2, _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2);
            float Constant_24ddbb0ae8e3453497d7e1d69eb92f9b = 3.141593;
            float _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float;
            Unity_Divide_float(Constant_24ddbb0ae8e3453497d7e1d69eb92f9b, float(2), _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float);
            float2 _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2 = float2( _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float.x, float(1).x );
            float4 _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4;
            GetHexId_float(_Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2, _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2, _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4);
            float4 _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4;
            Unity_ChannelMask_RedGreen_float4 (_GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4);
            float _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float;
            Unity_DotProduct_float4(_ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float);
            float _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float = _Hex_Strength;
            float _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float, _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float);
            float4 _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float.xxxx), _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4);
            float _Property_03febe4d2552499d86fe66485d788775_Out_0_Float = _Edge_Intensity;
            float4 _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, (_Property_03febe4d2552499d86fe66485d788775_Out_0_Float.xxxx), _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4);
            float _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, IN.WorldSpaceNormal, _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float);
            float _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float;
            Unity_Absolute_float(_DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float, _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float);
            float _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float;
            Unity_OneMinus_float(_Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float, _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float);
            float _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float = _Edge_Center_Opacity_Contrast;
            float _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float;
            Unity_Power_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float, _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float);
            float _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float);
            float4 _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_786f814fedb440ca87c4603d5f99a982_R_1_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[0];
            float _Split_786f814fedb440ca87c4603d5f99a982_G_2_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[1];
            float _Split_786f814fedb440ca87c4603d5f99a982_B_3_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[2];
            float _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[3];
            float _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float, _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float, _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float);
            float _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float = _Depth_Detection_Distance;
            float _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float;
            Unity_Divide_float(_Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float, _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float, _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float);
            float _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float;
            Unity_Saturate_float(_Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float, _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float);
            float _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float, _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float);
            float _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float = _Depth_Detection_Interior_Intensity;
            float _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float);
            float _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float;
            Unity_Maximum_float(_Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float, _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float);
            float _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float, _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float);
            float _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float = _Edge_Border_Opacity_Intensity;
            float _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float, _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float);
            float _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float = _Edge_Border_Opacity_Contrast;
            float _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float;
            Unity_Power_float(_Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float, _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float, _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float);
            float _Property_799279434a654795993568fc9fbccd27_Out_0_Float = _Depth_Detection_Constrast;
            float _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float;
            Unity_Power_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_799279434a654795993568fc9fbccd27_Out_0_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float);
            float _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float;
            Unity_Maximum_float(_Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float);
            float _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
            Unity_Maximum_float(_Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            float4 _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4;
            Unity_Blend_Lighten_float4(_Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4, _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4, _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            surface.BaseColor = (_Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
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
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
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
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
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
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
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
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
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
        float _Hex_Strength;
        float4 _Color;
        float _Interior_Intensity;
        float _Edge_Intensity;
        float _Time_Speed;
        float2 _UV_Tile;
        float _Edge_Border_Opacity_Contrast;
        float _Edge_Center_Opacity_Contrast;
        float _Edge_Border_Opacity_Intensity;
        float _Depth_Detection_Distance;
        float _Depth_Detection_Constrast;
        float _Depth_Detection_Interior_Intensity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        // unity-custom-func-begin
        void GetHexId_float(float2 p, float2 hexSize, out float4 result){
            float4 h = float4(p, p - hexSize/2.0);
            float4 iC = floor(h/hexSize.xyxy) + 0.5;
            h -= iC*hexSize.xyxy;
            result = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? float4(h.xy, iC.xy) : float4(h.zw, iC.zw + .5);
        }
        // unity-custom-func-end
        
        void Unity_ChannelMask_RedGreen_float4 (float4 In, out float4 Out)
        {
            Out = float4(In.r, In.g, 0, 0);
        }
        
        void Unity_DotProduct_float4(float4 A, float4 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
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
            description.Position = IN.ObjectSpacePosition;
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4 = IN.uv0;
            float2 _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2 = _UV_Tile;
            float2 _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4.xy), _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2, _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2);
            float _Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float = _Time_Speed;
            float _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float, IN.TimeParameters.x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float);
            float2 _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2 = float2( float(0).x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float.x );
            float2 _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2, _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2, _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2);
            float Constant_24ddbb0ae8e3453497d7e1d69eb92f9b = 3.141593;
            float _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float;
            Unity_Divide_float(Constant_24ddbb0ae8e3453497d7e1d69eb92f9b, float(2), _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float);
            float2 _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2 = float2( _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float.x, float(1).x );
            float4 _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4;
            GetHexId_float(_Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2, _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2, _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4);
            float4 _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4;
            Unity_ChannelMask_RedGreen_float4 (_GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4);
            float _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float;
            Unity_DotProduct_float4(_ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float);
            float _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float = _Hex_Strength;
            float _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float, _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float);
            float4 _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float.xxxx), _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4);
            float _Property_03febe4d2552499d86fe66485d788775_Out_0_Float = _Edge_Intensity;
            float4 _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, (_Property_03febe4d2552499d86fe66485d788775_Out_0_Float.xxxx), _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4);
            float _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, IN.WorldSpaceNormal, _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float);
            float _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float;
            Unity_Absolute_float(_DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float, _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float);
            float _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float;
            Unity_OneMinus_float(_Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float, _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float);
            float _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float = _Edge_Center_Opacity_Contrast;
            float _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float;
            Unity_Power_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float, _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float);
            float _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float);
            float4 _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_786f814fedb440ca87c4603d5f99a982_R_1_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[0];
            float _Split_786f814fedb440ca87c4603d5f99a982_G_2_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[1];
            float _Split_786f814fedb440ca87c4603d5f99a982_B_3_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[2];
            float _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[3];
            float _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float, _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float, _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float);
            float _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float = _Depth_Detection_Distance;
            float _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float;
            Unity_Divide_float(_Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float, _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float, _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float);
            float _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float;
            Unity_Saturate_float(_Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float, _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float);
            float _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float, _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float);
            float _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float = _Depth_Detection_Interior_Intensity;
            float _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float);
            float _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float;
            Unity_Maximum_float(_Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float, _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float);
            float _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float, _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float);
            float _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float = _Edge_Border_Opacity_Intensity;
            float _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float, _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float);
            float _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float = _Edge_Border_Opacity_Contrast;
            float _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float;
            Unity_Power_float(_Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float, _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float, _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float);
            float _Property_799279434a654795993568fc9fbccd27_Out_0_Float = _Depth_Detection_Constrast;
            float _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float;
            Unity_Power_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_799279434a654795993568fc9fbccd27_Out_0_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float);
            float _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float;
            Unity_Maximum_float(_Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float);
            float _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
            Unity_Maximum_float(_Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            float4 _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4;
            Unity_Blend_Lighten_float4(_Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4, _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4, _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            surface.BaseColor = (_Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
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
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        
        
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
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
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
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Hex_Strength;
        float4 _Color;
        float _Interior_Intensity;
        float _Edge_Intensity;
        float _Time_Speed;
        float2 _UV_Tile;
        float _Edge_Border_Opacity_Contrast;
        float _Edge_Center_Opacity_Contrast;
        float _Edge_Border_Opacity_Intensity;
        float _Depth_Detection_Distance;
        float _Depth_Detection_Constrast;
        float _Depth_Detection_Interior_Intensity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        // unity-custom-func-begin
        void GetHexId_float(float2 p, float2 hexSize, out float4 result){
            float4 h = float4(p, p - hexSize/2.0);
            float4 iC = floor(h/hexSize.xyxy) + 0.5;
            h -= iC*hexSize.xyxy;
            result = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? float4(h.xy, iC.xy) : float4(h.zw, iC.zw + .5);
        }
        // unity-custom-func-end
        
        void Unity_ChannelMask_RedGreen_float4 (float4 In, out float4 Out)
        {
            Out = float4(In.r, In.g, 0, 0);
        }
        
        void Unity_DotProduct_float4(float4 A, float4 B, out float Out)
        {
            Out = dot(A, B);
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
            description.Position = IN.ObjectSpacePosition;
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, IN.WorldSpaceNormal, _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float);
            float _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float;
            Unity_Absolute_float(_DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float, _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float);
            float _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float;
            Unity_OneMinus_float(_Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float, _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float);
            float _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float = _Edge_Center_Opacity_Contrast;
            float _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float;
            Unity_Power_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float, _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float);
            float _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float);
            float4 _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_786f814fedb440ca87c4603d5f99a982_R_1_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[0];
            float _Split_786f814fedb440ca87c4603d5f99a982_G_2_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[1];
            float _Split_786f814fedb440ca87c4603d5f99a982_B_3_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[2];
            float _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[3];
            float _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float, _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float, _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float);
            float _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float = _Depth_Detection_Distance;
            float _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float;
            Unity_Divide_float(_Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float, _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float, _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float);
            float _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float;
            Unity_Saturate_float(_Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float, _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float);
            float _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float, _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float);
            float _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float = _Depth_Detection_Interior_Intensity;
            float _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float);
            float _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float;
            Unity_Maximum_float(_Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float, _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float);
            float4 _UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4 = IN.uv0;
            float2 _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2 = _UV_Tile;
            float2 _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4.xy), _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2, _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2);
            float _Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float = _Time_Speed;
            float _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float, IN.TimeParameters.x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float);
            float2 _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2 = float2( float(0).x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float.x );
            float2 _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2, _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2, _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2);
            float Constant_24ddbb0ae8e3453497d7e1d69eb92f9b = 3.141593;
            float _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float;
            Unity_Divide_float(Constant_24ddbb0ae8e3453497d7e1d69eb92f9b, float(2), _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float);
            float2 _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2 = float2( _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float.x, float(1).x );
            float4 _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4;
            GetHexId_float(_Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2, _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2, _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4);
            float4 _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4;
            Unity_ChannelMask_RedGreen_float4 (_GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4);
            float _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float;
            Unity_DotProduct_float4(_ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float);
            float _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float = _Hex_Strength;
            float _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float, _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float);
            float _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float, _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float);
            float _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float = _Edge_Border_Opacity_Intensity;
            float _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float, _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float);
            float _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float = _Edge_Border_Opacity_Contrast;
            float _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float;
            Unity_Power_float(_Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float, _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float, _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float);
            float _Property_799279434a654795993568fc9fbccd27_Out_0_Float = _Depth_Detection_Constrast;
            float _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float;
            Unity_Power_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_799279434a654795993568fc9fbccd27_Out_0_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float);
            float _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float;
            Unity_Maximum_float(_Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float);
            float _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
            Unity_Maximum_float(_Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            surface.Alpha = _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
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
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define REQUIRE_DEPTH_TEXTURE
        
        
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
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
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
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Hex_Strength;
        float4 _Color;
        float _Interior_Intensity;
        float _Edge_Intensity;
        float _Time_Speed;
        float2 _UV_Tile;
        float _Edge_Border_Opacity_Contrast;
        float _Edge_Center_Opacity_Contrast;
        float _Edge_Border_Opacity_Intensity;
        float _Depth_Detection_Distance;
        float _Depth_Detection_Constrast;
        float _Depth_Detection_Interior_Intensity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        // unity-custom-func-begin
        void GetHexId_float(float2 p, float2 hexSize, out float4 result){
            float4 h = float4(p, p - hexSize/2.0);
            float4 iC = floor(h/hexSize.xyxy) + 0.5;
            h -= iC*hexSize.xyxy;
            result = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? float4(h.xy, iC.xy) : float4(h.zw, iC.zw + .5);
        }
        // unity-custom-func-end
        
        void Unity_ChannelMask_RedGreen_float4 (float4 In, out float4 Out)
        {
            Out = float4(In.r, In.g, 0, 0);
        }
        
        void Unity_DotProduct_float4(float4 A, float4 B, out float Out)
        {
            Out = dot(A, B);
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
            description.Position = IN.ObjectSpacePosition;
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, IN.WorldSpaceNormal, _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float);
            float _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float;
            Unity_Absolute_float(_DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float, _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float);
            float _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float;
            Unity_OneMinus_float(_Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float, _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float);
            float _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float = _Edge_Center_Opacity_Contrast;
            float _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float;
            Unity_Power_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float, _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float);
            float _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float);
            float4 _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_786f814fedb440ca87c4603d5f99a982_R_1_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[0];
            float _Split_786f814fedb440ca87c4603d5f99a982_G_2_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[1];
            float _Split_786f814fedb440ca87c4603d5f99a982_B_3_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[2];
            float _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[3];
            float _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float, _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float, _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float);
            float _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float = _Depth_Detection_Distance;
            float _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float;
            Unity_Divide_float(_Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float, _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float, _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float);
            float _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float;
            Unity_Saturate_float(_Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float, _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float);
            float _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float, _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float);
            float _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float = _Depth_Detection_Interior_Intensity;
            float _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float);
            float _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float;
            Unity_Maximum_float(_Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float, _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float);
            float4 _UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4 = IN.uv0;
            float2 _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2 = _UV_Tile;
            float2 _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4.xy), _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2, _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2);
            float _Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float = _Time_Speed;
            float _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float, IN.TimeParameters.x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float);
            float2 _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2 = float2( float(0).x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float.x );
            float2 _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2, _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2, _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2);
            float Constant_24ddbb0ae8e3453497d7e1d69eb92f9b = 3.141593;
            float _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float;
            Unity_Divide_float(Constant_24ddbb0ae8e3453497d7e1d69eb92f9b, float(2), _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float);
            float2 _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2 = float2( _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float.x, float(1).x );
            float4 _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4;
            GetHexId_float(_Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2, _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2, _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4);
            float4 _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4;
            Unity_ChannelMask_RedGreen_float4 (_GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4);
            float _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float;
            Unity_DotProduct_float4(_ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float);
            float _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float = _Hex_Strength;
            float _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float, _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float);
            float _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float, _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float);
            float _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float = _Edge_Border_Opacity_Intensity;
            float _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float, _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float);
            float _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float = _Edge_Border_Opacity_Contrast;
            float _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float;
            Unity_Power_float(_Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float, _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float, _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float);
            float _Property_799279434a654795993568fc9fbccd27_Out_0_Float = _Depth_Detection_Constrast;
            float _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float;
            Unity_Power_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_799279434a654795993568fc9fbccd27_Out_0_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float);
            float _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float;
            Unity_Maximum_float(_Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float);
            float _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
            Unity_Maximum_float(_Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            surface.Alpha = _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
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
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        
        
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
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 positionWS : INTERP2;
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
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Hex_Strength;
        float4 _Color;
        float _Interior_Intensity;
        float _Edge_Intensity;
        float _Time_Speed;
        float2 _UV_Tile;
        float _Edge_Border_Opacity_Contrast;
        float _Edge_Center_Opacity_Contrast;
        float _Edge_Border_Opacity_Intensity;
        float _Depth_Detection_Distance;
        float _Depth_Detection_Constrast;
        float _Depth_Detection_Interior_Intensity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        // unity-custom-func-begin
        void GetHexId_float(float2 p, float2 hexSize, out float4 result){
            float4 h = float4(p, p - hexSize/2.0);
            float4 iC = floor(h/hexSize.xyxy) + 0.5;
            h -= iC*hexSize.xyxy;
            result = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? float4(h.xy, iC.xy) : float4(h.zw, iC.zw + .5);
        }
        // unity-custom-func-end
        
        void Unity_ChannelMask_RedGreen_float4 (float4 In, out float4 Out)
        {
            Out = float4(In.r, In.g, 0, 0);
        }
        
        void Unity_DotProduct_float4(float4 A, float4 B, out float Out)
        {
            Out = dot(A, B);
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
            description.Position = IN.ObjectSpacePosition;
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, IN.WorldSpaceNormal, _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float);
            float _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float;
            Unity_Absolute_float(_DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float, _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float);
            float _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float;
            Unity_OneMinus_float(_Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float, _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float);
            float _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float = _Edge_Center_Opacity_Contrast;
            float _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float;
            Unity_Power_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float, _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float);
            float _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float);
            float4 _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_786f814fedb440ca87c4603d5f99a982_R_1_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[0];
            float _Split_786f814fedb440ca87c4603d5f99a982_G_2_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[1];
            float _Split_786f814fedb440ca87c4603d5f99a982_B_3_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[2];
            float _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[3];
            float _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float, _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float, _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float);
            float _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float = _Depth_Detection_Distance;
            float _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float;
            Unity_Divide_float(_Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float, _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float, _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float);
            float _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float;
            Unity_Saturate_float(_Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float, _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float);
            float _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float, _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float);
            float _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float = _Depth_Detection_Interior_Intensity;
            float _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float);
            float _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float;
            Unity_Maximum_float(_Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float, _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float);
            float4 _UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4 = IN.uv0;
            float2 _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2 = _UV_Tile;
            float2 _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4.xy), _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2, _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2);
            float _Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float = _Time_Speed;
            float _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float, IN.TimeParameters.x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float);
            float2 _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2 = float2( float(0).x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float.x );
            float2 _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2, _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2, _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2);
            float Constant_24ddbb0ae8e3453497d7e1d69eb92f9b = 3.141593;
            float _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float;
            Unity_Divide_float(Constant_24ddbb0ae8e3453497d7e1d69eb92f9b, float(2), _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float);
            float2 _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2 = float2( _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float.x, float(1).x );
            float4 _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4;
            GetHexId_float(_Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2, _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2, _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4);
            float4 _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4;
            Unity_ChannelMask_RedGreen_float4 (_GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4);
            float _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float;
            Unity_DotProduct_float4(_ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float);
            float _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float = _Hex_Strength;
            float _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float, _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float);
            float _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float, _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float);
            float _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float = _Edge_Border_Opacity_Intensity;
            float _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float, _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float);
            float _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float = _Edge_Border_Opacity_Contrast;
            float _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float;
            Unity_Power_float(_Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float, _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float, _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float);
            float _Property_799279434a654795993568fc9fbccd27_Out_0_Float = _Depth_Detection_Constrast;
            float _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float;
            Unity_Power_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_799279434a654795993568fc9fbccd27_Out_0_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float);
            float _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float;
            Unity_Maximum_float(_Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float);
            float _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
            Unity_Maximum_float(_Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
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
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #define ATTRIBUTES_NEED_INSTANCEID
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
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
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
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
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float3 positionWS : INTERP3;
             float3 normalWS : INTERP4;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
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
        float _Hex_Strength;
        float4 _Color;
        float _Interior_Intensity;
        float _Edge_Intensity;
        float _Time_Speed;
        float2 _UV_Tile;
        float _Edge_Border_Opacity_Contrast;
        float _Edge_Center_Opacity_Contrast;
        float _Edge_Border_Opacity_Intensity;
        float _Depth_Detection_Distance;
        float _Depth_Detection_Constrast;
        float _Depth_Detection_Interior_Intensity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        // unity-custom-func-begin
        void GetHexId_float(float2 p, float2 hexSize, out float4 result){
            float4 h = float4(p, p - hexSize/2.0);
            float4 iC = floor(h/hexSize.xyxy) + 0.5;
            h -= iC*hexSize.xyxy;
            result = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? float4(h.xy, iC.xy) : float4(h.zw, iC.zw + .5);
        }
        // unity-custom-func-end
        
        void Unity_ChannelMask_RedGreen_float4 (float4 In, out float4 Out)
        {
            Out = float4(In.r, In.g, 0, 0);
        }
        
        void Unity_DotProduct_float4(float4 A, float4 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
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
            description.Position = IN.ObjectSpacePosition;
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4 = IN.uv0;
            float2 _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2 = _UV_Tile;
            float2 _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4.xy), _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2, _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2);
            float _Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float = _Time_Speed;
            float _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float, IN.TimeParameters.x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float);
            float2 _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2 = float2( float(0).x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float.x );
            float2 _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2, _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2, _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2);
            float Constant_24ddbb0ae8e3453497d7e1d69eb92f9b = 3.141593;
            float _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float;
            Unity_Divide_float(Constant_24ddbb0ae8e3453497d7e1d69eb92f9b, float(2), _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float);
            float2 _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2 = float2( _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float.x, float(1).x );
            float4 _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4;
            GetHexId_float(_Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2, _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2, _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4);
            float4 _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4;
            Unity_ChannelMask_RedGreen_float4 (_GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4);
            float _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float;
            Unity_DotProduct_float4(_ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float);
            float _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float = _Hex_Strength;
            float _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float, _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float);
            float4 _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float.xxxx), _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4);
            float _Property_03febe4d2552499d86fe66485d788775_Out_0_Float = _Edge_Intensity;
            float4 _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, (_Property_03febe4d2552499d86fe66485d788775_Out_0_Float.xxxx), _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4);
            float _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, IN.WorldSpaceNormal, _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float);
            float _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float;
            Unity_Absolute_float(_DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float, _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float);
            float _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float;
            Unity_OneMinus_float(_Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float, _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float);
            float _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float = _Edge_Center_Opacity_Contrast;
            float _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float;
            Unity_Power_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float, _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float);
            float _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float);
            float4 _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_786f814fedb440ca87c4603d5f99a982_R_1_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[0];
            float _Split_786f814fedb440ca87c4603d5f99a982_G_2_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[1];
            float _Split_786f814fedb440ca87c4603d5f99a982_B_3_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[2];
            float _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[3];
            float _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float, _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float, _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float);
            float _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float = _Depth_Detection_Distance;
            float _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float;
            Unity_Divide_float(_Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float, _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float, _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float);
            float _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float;
            Unity_Saturate_float(_Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float, _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float);
            float _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float, _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float);
            float _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float = _Depth_Detection_Interior_Intensity;
            float _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float);
            float _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float;
            Unity_Maximum_float(_Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float, _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float);
            float _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float, _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float);
            float _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float = _Edge_Border_Opacity_Intensity;
            float _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float, _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float);
            float _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float = _Edge_Border_Opacity_Contrast;
            float _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float;
            Unity_Power_float(_Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float, _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float, _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float);
            float _Property_799279434a654795993568fc9fbccd27_Out_0_Float = _Depth_Detection_Constrast;
            float _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float;
            Unity_Power_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_799279434a654795993568fc9fbccd27_Out_0_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float);
            float _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float;
            Unity_Maximum_float(_Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float);
            float _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
            Unity_Maximum_float(_Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            float4 _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4;
            Unity_Blend_Lighten_float4(_Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4, _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4, _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            surface.BaseColor = (_Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
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
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
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
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
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
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Hex_Strength;
        float4 _Color;
        float _Interior_Intensity;
        float _Edge_Intensity;
        float _Time_Speed;
        float2 _UV_Tile;
        float _Edge_Border_Opacity_Contrast;
        float _Edge_Center_Opacity_Contrast;
        float _Edge_Border_Opacity_Intensity;
        float _Depth_Detection_Distance;
        float _Depth_Detection_Constrast;
        float _Depth_Detection_Interior_Intensity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        // unity-custom-func-begin
        void GetHexId_float(float2 p, float2 hexSize, out float4 result){
            float4 h = float4(p, p - hexSize/2.0);
            float4 iC = floor(h/hexSize.xyxy) + 0.5;
            h -= iC*hexSize.xyxy;
            result = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? float4(h.xy, iC.xy) : float4(h.zw, iC.zw + .5);
        }
        // unity-custom-func-end
        
        void Unity_ChannelMask_RedGreen_float4 (float4 In, out float4 Out)
        {
            Out = float4(In.r, In.g, 0, 0);
        }
        
        void Unity_DotProduct_float4(float4 A, float4 B, out float Out)
        {
            Out = dot(A, B);
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
            description.Position = IN.ObjectSpacePosition;
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, IN.WorldSpaceNormal, _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float);
            float _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float;
            Unity_Absolute_float(_DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float, _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float);
            float _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float;
            Unity_OneMinus_float(_Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float, _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float);
            float _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float = _Edge_Center_Opacity_Contrast;
            float _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float;
            Unity_Power_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float, _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float);
            float _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float);
            float4 _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_786f814fedb440ca87c4603d5f99a982_R_1_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[0];
            float _Split_786f814fedb440ca87c4603d5f99a982_G_2_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[1];
            float _Split_786f814fedb440ca87c4603d5f99a982_B_3_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[2];
            float _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[3];
            float _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float, _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float, _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float);
            float _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float = _Depth_Detection_Distance;
            float _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float;
            Unity_Divide_float(_Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float, _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float, _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float);
            float _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float;
            Unity_Saturate_float(_Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float, _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float);
            float _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float, _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float);
            float _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float = _Depth_Detection_Interior_Intensity;
            float _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float);
            float _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float;
            Unity_Maximum_float(_Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float, _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float);
            float4 _UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4 = IN.uv0;
            float2 _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2 = _UV_Tile;
            float2 _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4.xy), _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2, _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2);
            float _Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float = _Time_Speed;
            float _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float, IN.TimeParameters.x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float);
            float2 _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2 = float2( float(0).x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float.x );
            float2 _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2, _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2, _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2);
            float Constant_24ddbb0ae8e3453497d7e1d69eb92f9b = 3.141593;
            float _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float;
            Unity_Divide_float(Constant_24ddbb0ae8e3453497d7e1d69eb92f9b, float(2), _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float);
            float2 _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2 = float2( _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float.x, float(1).x );
            float4 _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4;
            GetHexId_float(_Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2, _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2, _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4);
            float4 _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4;
            Unity_ChannelMask_RedGreen_float4 (_GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4);
            float _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float;
            Unity_DotProduct_float4(_ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float);
            float _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float = _Hex_Strength;
            float _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float, _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float);
            float _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float, _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float);
            float _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float = _Edge_Border_Opacity_Intensity;
            float _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float, _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float);
            float _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float = _Edge_Border_Opacity_Contrast;
            float _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float;
            Unity_Power_float(_Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float, _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float, _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float);
            float _Property_799279434a654795993568fc9fbccd27_Out_0_Float = _Depth_Detection_Constrast;
            float _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float;
            Unity_Power_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_799279434a654795993568fc9fbccd27_Out_0_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float);
            float _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float;
            Unity_Maximum_float(_Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float);
            float _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
            Unity_Maximum_float(_Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            surface.Alpha = _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
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
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
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
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
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
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Hex_Strength;
        float4 _Color;
        float _Interior_Intensity;
        float _Edge_Intensity;
        float _Time_Speed;
        float2 _UV_Tile;
        float _Edge_Border_Opacity_Contrast;
        float _Edge_Center_Opacity_Contrast;
        float _Edge_Border_Opacity_Intensity;
        float _Depth_Detection_Distance;
        float _Depth_Detection_Constrast;
        float _Depth_Detection_Interior_Intensity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        // unity-custom-func-begin
        void GetHexId_float(float2 p, float2 hexSize, out float4 result){
            float4 h = float4(p, p - hexSize/2.0);
            float4 iC = floor(h/hexSize.xyxy) + 0.5;
            h -= iC*hexSize.xyxy;
            result = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? float4(h.xy, iC.xy) : float4(h.zw, iC.zw + .5);
        }
        // unity-custom-func-end
        
        void Unity_ChannelMask_RedGreen_float4 (float4 In, out float4 Out)
        {
            Out = float4(In.r, In.g, 0, 0);
        }
        
        void Unity_DotProduct_float4(float4 A, float4 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
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
            description.Position = IN.ObjectSpacePosition;
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4 = IN.uv0;
            float2 _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2 = _UV_Tile;
            float2 _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4.xy), _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2, _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2);
            float _Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float = _Time_Speed;
            float _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float, IN.TimeParameters.x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float);
            float2 _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2 = float2( float(0).x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float.x );
            float2 _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2, _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2, _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2);
            float Constant_24ddbb0ae8e3453497d7e1d69eb92f9b = 3.141593;
            float _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float;
            Unity_Divide_float(Constant_24ddbb0ae8e3453497d7e1d69eb92f9b, float(2), _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float);
            float2 _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2 = float2( _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float.x, float(1).x );
            float4 _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4;
            GetHexId_float(_Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2, _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2, _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4);
            float4 _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4;
            Unity_ChannelMask_RedGreen_float4 (_GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4);
            float _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float;
            Unity_DotProduct_float4(_ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float);
            float _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float = _Hex_Strength;
            float _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float, _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float);
            float4 _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float.xxxx), _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4);
            float _Property_03febe4d2552499d86fe66485d788775_Out_0_Float = _Edge_Intensity;
            float4 _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, (_Property_03febe4d2552499d86fe66485d788775_Out_0_Float.xxxx), _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4);
            float _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, IN.WorldSpaceNormal, _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float);
            float _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float;
            Unity_Absolute_float(_DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float, _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float);
            float _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float;
            Unity_OneMinus_float(_Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float, _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float);
            float _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float = _Edge_Center_Opacity_Contrast;
            float _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float;
            Unity_Power_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float, _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float);
            float _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float);
            float4 _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_786f814fedb440ca87c4603d5f99a982_R_1_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[0];
            float _Split_786f814fedb440ca87c4603d5f99a982_G_2_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[1];
            float _Split_786f814fedb440ca87c4603d5f99a982_B_3_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[2];
            float _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[3];
            float _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float, _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float, _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float);
            float _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float = _Depth_Detection_Distance;
            float _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float;
            Unity_Divide_float(_Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float, _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float, _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float);
            float _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float;
            Unity_Saturate_float(_Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float, _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float);
            float _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float, _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float);
            float _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float = _Depth_Detection_Interior_Intensity;
            float _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float);
            float _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float;
            Unity_Maximum_float(_Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float, _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float);
            float _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float, _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float);
            float _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float = _Edge_Border_Opacity_Intensity;
            float _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float, _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float);
            float _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float = _Edge_Border_Opacity_Contrast;
            float _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float;
            Unity_Power_float(_Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float, _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float, _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float);
            float _Property_799279434a654795993568fc9fbccd27_Out_0_Float = _Depth_Detection_Constrast;
            float _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float;
            Unity_Power_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_799279434a654795993568fc9fbccd27_Out_0_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float);
            float _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float;
            Unity_Maximum_float(_Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float);
            float _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
            Unity_Maximum_float(_Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            float4 _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4;
            Unity_Blend_Lighten_float4(_Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4, _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4, _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            surface.BaseColor = (_Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4.xyz);
            surface.Alpha = _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
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
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
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
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        
        
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
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
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
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Hex_Strength;
        float4 _Color;
        float _Interior_Intensity;
        float _Edge_Intensity;
        float _Time_Speed;
        float2 _UV_Tile;
        float _Edge_Border_Opacity_Contrast;
        float _Edge_Center_Opacity_Contrast;
        float _Edge_Border_Opacity_Intensity;
        float _Depth_Detection_Distance;
        float _Depth_Detection_Constrast;
        float _Depth_Detection_Interior_Intensity;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
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
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        // unity-custom-func-begin
        void GetHexId_float(float2 p, float2 hexSize, out float4 result){
            float4 h = float4(p, p - hexSize/2.0);
            float4 iC = floor(h/hexSize.xyxy) + 0.5;
            h -= iC*hexSize.xyxy;
            result = dot(h.xy, h.xy)<dot(h.zw, h.zw) ? float4(h.xy, iC.xy) : float4(h.zw, iC.zw + .5);
        }
        // unity-custom-func-end
        
        void Unity_ChannelMask_RedGreen_float4 (float4 In, out float4 Out)
        {
            Out = float4(In.r, In.g, 0, 0);
        }
        
        void Unity_DotProduct_float4(float4 A, float4 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
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
            description.Position = IN.ObjectSpacePosition;
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
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4 = IN.uv0;
            float2 _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2 = _UV_Tile;
            float2 _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2;
            Unity_Multiply_float2_float2((_UV_ab39bc35905f40849d36f36cf32b3270_Out_0_Vector4.xy), _Property_3e64062701d44edab1b77187b83f9aeb_Out_0_Vector2, _Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2);
            float _Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float = _Time_Speed;
            float _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float;
            Unity_Multiply_float_float(_Property_c4907a3ed0a6424aa43bd40bc420daaf_Out_0_Float, IN.TimeParameters.x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float);
            float2 _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2 = float2( float(0).x, _Multiply_7b46474522aa4ed4b8dc66832c40e1d1_Out_2_Float.x );
            float2 _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2;
            Unity_Add_float2(_Multiply_e421fef864544813ba4fa49a6ed7a17b_Out_2_Vector2, _Append_9703b40878a249929b41a9ff70ad55fb_Out_2_Vector2, _Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2);
            float Constant_24ddbb0ae8e3453497d7e1d69eb92f9b = 3.141593;
            float _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float;
            Unity_Divide_float(Constant_24ddbb0ae8e3453497d7e1d69eb92f9b, float(2), _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float);
            float2 _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2 = float2( _Divide_ec9b54e24434408b99c7cc3591b477f1_Out_2_Float.x, float(1).x );
            float4 _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4;
            GetHexId_float(_Add_789e85223f7a4a3fa0ddec0e970aebc8_Out_2_Vector2, _Append_957f3b9f094b4c5788328954bc3aaf6c_Out_2_Vector2, _GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4);
            float4 _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4;
            Unity_ChannelMask_RedGreen_float4 (_GetHexIdCustomFunction_807a9e95d5ff4a508b3488914b596852_result_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4);
            float _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float;
            Unity_DotProduct_float4(_ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _ChannelMask_c08c1951bd074e69806b53d044fe20f6_Out_1_Vector4, _DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float);
            float _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float = _Hex_Strength;
            float _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_7c11572005d54e498a62264ade7899ac_Out_2_Float, _Property_6a3f3782d4bd41bf885f7ed0adc8a9f7_Out_0_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float);
            float4 _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_Color) : _Color;
            float4 _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float.xxxx), _Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, _Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4);
            float _Property_03febe4d2552499d86fe66485d788775_Out_0_Float = _Edge_Intensity;
            float4 _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_c815b70e058e4c21b009aaa3edb06f18_Out_0_Vector4, (_Property_03febe4d2552499d86fe66485d788775_Out_0_Float.xxxx), _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4);
            float _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceViewDirection, IN.WorldSpaceNormal, _DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float);
            float _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float;
            Unity_Absolute_float(_DotProduct_6e64f122b2214cc9a5016df8208b8248_Out_2_Float, _Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float);
            float _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float;
            Unity_OneMinus_float(_Absolute_7286080546834b1fa61fc979f4b4c757_Out_1_Float, _OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float);
            float _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float = _Edge_Center_Opacity_Contrast;
            float _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float;
            Unity_Power_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_cad15eb1003b4ea2b6927bedc4f8413c_Out_0_Float, _Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float);
            float _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float);
            float4 _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_786f814fedb440ca87c4603d5f99a982_R_1_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[0];
            float _Split_786f814fedb440ca87c4603d5f99a982_G_2_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[1];
            float _Split_786f814fedb440ca87c4603d5f99a982_B_3_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[2];
            float _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float = _ScreenPosition_5bf74747615b4074bf09f1f713d62101_Out_0_Vector4[3];
            float _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_045a3462dd8848329d62d2c8c39c6b59_Out_1_Float, _Split_786f814fedb440ca87c4603d5f99a982_A_4_Float, _Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float);
            float _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float = _Depth_Detection_Distance;
            float _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float;
            Unity_Divide_float(_Subtract_c0f60ecd3b0542d18261093a0ada87ae_Out_2_Float, _Property_7e8e960295334ede8067f5a9aa39fb21_Out_0_Float, _Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float);
            float _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float;
            Unity_Saturate_float(_Divide_d66d233d75f24522829ea595924b56e0_Out_2_Float, _Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float);
            float _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float;
            Unity_OneMinus_float(_Saturate_577dd7b37198464da4e65895a0ed998c_Out_1_Float, _OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float);
            float _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float = _Depth_Detection_Interior_Intensity;
            float _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_ab3de83bb82140db96c9abf62c0c067e_Out_0_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float);
            float _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float;
            Unity_Maximum_float(_Power_9120edbf72b04ee597cf130cb3427837_Out_2_Float, _Multiply_8d32351100364e2b8c1ec6d7f4b37cca_Out_2_Float, _Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float);
            float _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float;
            Unity_Multiply_float_float(_Maximum_c44f2aa0b89c4e0bb423997b2a221b04_Out_2_Float, _Multiply_c250fb47db3049a3828658ddb28eb398_Out_2_Float, _Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float);
            float _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float = _Edge_Border_Opacity_Intensity;
            float _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float;
            Unity_Multiply_float_float(_OneMinus_98fdc9ad5ee8474abdc4cf728309aae5_Out_1_Float, _Property_30c3654731a94aafa498dd21603c4286_Out_0_Float, _Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float);
            float _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float = _Edge_Border_Opacity_Contrast;
            float _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float;
            Unity_Power_float(_Multiply_2ab4d3db858d4df8b52b7354aefbe193_Out_2_Float, _Property_e7be1830c3584680a0dc1e3b12b78fec_Out_0_Float, _Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float);
            float _Property_799279434a654795993568fc9fbccd27_Out_0_Float = _Depth_Detection_Constrast;
            float _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float;
            Unity_Power_float(_OneMinus_26832d7b98f54a98ae94d690ba6893e9_Out_1_Float, _Property_799279434a654795993568fc9fbccd27_Out_0_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float);
            float _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float;
            Unity_Maximum_float(_Power_3863cd3ac4404687a9071f819b9ebcc4_Out_2_Float, _Power_265834aac6c04afea8e68a9717d29747_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float);
            float _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
            Unity_Maximum_float(_Multiply_354c8ab5c1a5456dabf0f8cfffd94f8b_Out_2_Float, _Maximum_02f572dfaf3a43c78df4cb06c2b65b09_Out_2_Float, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            float4 _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4;
            Unity_Blend_Lighten_float4(_Multiply_3a0e2db9c7854edda5d04eb73051021e_Out_2_Vector4, _Multiply_2ad0202896184dd682452eb0979c42d0_Out_2_Vector4, _Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4, _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float);
            surface.BaseColor = (_Blend_09004a2b95e346998c479880293f7b95_Out_2_Vector4.xyz);
            surface.Alpha = _Maximum_5b6ef5898335465ba649c5d70b77bb31_Out_2_Float;
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
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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