using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class DynamicShadow : MonoBehaviour
{
    public const string kDynamicShadowSizeTag = "_DynamicShadowSize";
    public const string kDynamicShadowTextureTag = "_DynamicShadowTexture";
    public const string kDynamicShadowMatrixTag = "_DynamicShadowMatrix";
    public const string kDynamicShadowParamTag = "_DynamicShadowParam";

    public int m_ShadowSize = 1024;
    public bool m_SoftShadow = true;

    private RenderTexture m_DepthTexture;
    private Shader m_DepthShader;
    private Camera m_DepthCamera;

    public void Initialize()
    {
        if (m_DepthTexture == null)
        {
            var isSupportDepthTexture = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.Depth);

            if (!isSupportDepthTexture)
            {
                Shader.EnableKeyword("DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE");
            }
            else
            {
                Shader.DisableKeyword("DYNAMIC_SHADOW_USE_ARGB_DEPTH_TEXTURE");
            }

            if (m_SoftShadow)
            {
                Shader.EnableKeyword("DYNAMIC_SHADOW_USE_SOFT");
            }
            else
            {
                Shader.DisableKeyword("DYNAMIC_SHADOW_USE_SOFT");
            }

            m_DepthTexture = new RenderTexture(
                m_ShadowSize,
                m_ShadowSize,
                24,
                isSupportDepthTexture ? RenderTextureFormat.Depth : RenderTextureFormat.ARGB32,
                RenderTextureReadWrite.Default);
            m_DepthTexture.generateMips = false;
            m_DepthTexture.filterMode = FilterMode.Bilinear; // TODO FilterMode.Point or FilterMode.Bilinear

            if (m_DepthTexture == null)
            {
                throw new System.NotSupportedException("RenderTexture");
            }
        }

        if (m_DepthShader == null)
        {
            m_DepthShader = Shader.Find("DynamicShadow/ShadowDepth");

            if (m_DepthShader == null)
            {
                throw new System.NotSupportedException("Shader: DynamicShadow/ShadowDepth");
            }
        }

        if (m_DepthCamera == null)
        {
            m_DepthCamera = GetComponent<Camera>();

            if (m_DepthCamera != null)
            {
                m_DepthCamera.enabled = true;
                m_DepthCamera.targetTexture = m_DepthTexture;
                m_DepthCamera.backgroundColor = Color.white;
                m_DepthCamera.clearFlags = CameraClearFlags.SolidColor;
                m_DepthCamera.orthographic = true;
                m_DepthCamera.orthographicSize = 4;
                m_DepthCamera.nearClipPlane = 0.0001f;
                m_DepthCamera.farClipPlane = 40;
                m_DepthCamera.SetReplacementShader(m_DepthShader, "RenderType");
            }
        }

        Shader.SetGlobalFloat(kDynamicShadowSizeTag, m_ShadowSize);
    }

    public void Release()
    {
        if (m_DepthTexture)
        {
            m_DepthTexture.Release();
            m_DepthTexture = null;
        }

        m_DepthShader = null;

        if (m_DepthCamera)
        {
            m_DepthCamera.enabled = false;
            m_DepthCamera = null;
        }

        Shader.SetGlobalTexture(kDynamicShadowTextureTag, null);
    }

    #region MonoBehaviour
    private void OnEnable()
    {
        Initialize();
    }

    private void OnDisable()
    {
        Release();
    }

    private void OnPreRender()
    {
        Shader.SetGlobalTexture(kDynamicShadowTextureTag, null);
    }

    private void OnPostRender()
    {
        if (m_DepthTexture)
        {
            Shader.SetGlobalTexture(kDynamicShadowTextureTag, m_DepthTexture);
        }
    }

    private void LateUpdate()
    {
        if (m_DepthShader && m_DepthCamera)
        {
            // GL.GetGPUProjectionMatrix(m_DepthCamera.projectionMatrix, false) ?
            Matrix4x4 matrix4x = m_DepthCamera.projectionMatrix * m_DepthCamera.worldToCameraMatrix;
            Vector4 vector = transform.forward.normalized;
            Shader.SetGlobalMatrix(kDynamicShadowMatrixTag, matrix4x); // light direction
            Shader.SetGlobalVector(kDynamicShadowParamTag, vector);
        }
    }
    #endregion
}
