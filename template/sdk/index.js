const { PodTemplateSpec, Pod,Container } = require('kubernetes-models/v1')
const { Deployment } = require('kubernetes-models/apps/v1')
const k8s = require('@kubernetes/client-node')

const awsRegion = process.env['AWS_REGION'] || "ap-southeast-1";
const awsSSMPrefix = process.env['AWS_SSM_PREFIX'] || "/dev/sample/";
const image = process.env['DEPLOYMENT_IMAGE'] || "alfianabdi/sample:v0.3-multistage-scratch"

const kc = new k8s.KubeConfig()
if (process.env["KUBECONFIG"]) {
    kc.loadFromFile(process.env["KUBECONFIG"])
} else {
    kc.loadFromDefault()
}
const k8sApi = kc.makeApiClient(k8s.AppsV1Api)

const deployment = new Deployment({
    metadata: {
        name: "sample-scratch",
        labels: {
            app: "sample-scratch",
            kind: "sample"
        }
    },
    spec: {
        replicas: 1,
        selector: {
            matchLabels: {
                app: "sample-scratch",
                kind: "sample"
            }
        },
        template: new PodTemplateSpec({
            metadata: {
                labels: {
                    app: "sample-scratch",
                    kind: "sample"
                }
            },
            spec: {
                containers: [
                    new Container({
                        name: "sample-scratch",
                        ports: [
                            {containerPort: 8000}
                        ],
                        image: image,
                        env: [
                            {name: "AWS_REGION", value: awsRegion},
                            {name: "AWS_SSM_PREFIX", value: awsSSMPrefix},
                        ]
                    })
                ]
            }
        })
    }
})

// console.log(JSON.stringify(deployment));

// k8sApi.createNamespacedDeployment('default', deployment)
// .then( r => console.log(r))
// .catch( e => console.log(e));