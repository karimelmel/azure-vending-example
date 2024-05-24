
using '../../infra-as-code/archetypes/brownfield/brownfield.bicep'

param pimSubscriptionRoleAssignments = [
  {
    PrincipalId: '65694bb7-8b15-4e86-8afa-b93cfb8ec71f'
    Definition: 'Owner'
    subscriptionId: '0cb5e2fc-ed73-4e64-976e-683d2c3deccf'
  }
  {
    PrincipalId: '0b0937be-4bc0-4e89-a8c7-d9464789b1fb'
    Definition: 'Contributor'
    subscriptionId: 'c3dfd406-aadf-4de7-93d9-20c5b9f65418'
  }
  {
    PrincipalId: '181386cc-5f96-4f80-a528-d15858ef94ae'
    Definition: 'Owner'
    subscriptionId: 'c3dfd406-aadf-4de7-93d9-20c5b9f65418'
  }
  {
    PrincipalId: '11ad283f-05af-4235-aea6-432db722f96c'
    Definition: 'Owner'
    subscriptionId: '6c892474-337d-4ba9-ae0e-dab7ab195fb0'
  }
  {
    PrincipalId: '5a87748b-3c40-44e3-9608-20a08bd38ea0'
    Definition: 'Contributor'
    subscriptionId: '6c892474-337d-4ba9-ae0e-dab7ab195fb0'
  }
  {
    PrincipalId: '59a7659f-61da-49d8-9c69-fa6fd2fd29ac'
    Definition: 'Contributor'
    subscriptionId: '93283da2-455d-4f7a-a4b8-b37a17ad4a4f'
  }
  {
    PrincipalId: '07ac33db-0753-46ba-977d-72b640fe6e71'
    Definition: 'Owner'
    subscriptionId: '93283da2-455d-4f7a-a4b8-b37a17ad4a4f'
  }
  {
    PrincipalId: '32ea3a71-511c-41ed-9e49-4d7ba534dff3'
    Definition: 'Contributor'
    subscriptionId: 'aa80fc68-6f40-4c61-9fa7-a857227e2432'
  }
  {
    PrincipalId: '29c0c636-2f08-49fb-928b-2cb4fa5e24e1'
    Definition: 'Owner'
    subscriptionId: 'aa80fc68-6f40-4c61-9fa7-a857227e2432'
  }
  {
    PrincipalId: '78967eff-e54c-48d8-83ab-2489730b20fb'
    Definition: 'Owner'
    subscriptionId: '84885c98-af34-4edd-82f7-932a7085d7ec'
  }
  {
    PrincipalId: 'ae1c1c07-3114-4b6e-8552-5ed9516df4a2'
    Definition: 'Contributor'
    subscriptionId: '84885c98-af34-4edd-82f7-932a7085d7ec'
  }
  {
    PrincipalId: 'e6f61351-ea25-4cd8-8261-4fbd70a01e94'
    Definition: 'Owner'
    subscriptionId: '076de658-c8f1-42e0-813e-bf4ffa106656'
  }
  {
    PrincipalId: 'aae64327-a208-44d6-b507-462977dbc6ed'
    Definition: 'Contributor'
    subscriptionId: '076de658-c8f1-42e0-813e-bf4ffa106656'
  }
  {
    PrincipalId: '7f06071b-144c-428a-a02a-1dd70e6ece12'
    Definition: 'Owner'
    subscriptionId: '370b7d4a-16b7-4ef1-894e-0590b7e101c7'
  }
  {
    PrincipalId: '0b0070f3-1e99-4389-9d4a-90bdeee155e9'
    Definition: 'Reader'
    subscriptionId: '370b7d4a-16b7-4ef1-894e-0590b7e101c7'
  }
  {
    PrincipalId: 'd5f7c77d-0e19-4686-b31c-64425d00356c'
    Definition: 'Contributor'
    subscriptionId: '58d964b2-9282-48e8-b4e4-c9274530ef61'
  }
  {
    PrincipalId: 'e786e456-87b4-43ef-ae13-fbc094758f3e'
    Definition: 'Reader'
    subscriptionId: '59705d23-73f8-48b8-aacf-4dc6f07f227d'
  }
  {
    PrincipalId: 'e08850d8-9e50-4442-a181-cc71e1d2a200'
    Definition: 'Contributor'
    subscriptionId: '59705d23-73f8-48b8-aacf-4dc6f07f227d'
  }
  {
    PrincipalId: '4e14a02c-58ac-43e3-bd0d-564cfac8519e'
    Definition: 'Contributor'
    subscriptionId: 'd8731a64-8b4e-4d2f-bd7c-49466626f015'
  }
  {
    PrincipalId: 'f2923a72-aaac-4611-804c-ac9a14574045'
    Definition: 'Reader'
    subscriptionId: 'd8731a64-8b4e-4d2f-bd7c-49466626f015'
  }
  {
    PrincipalId: '03961bf2-8869-43ac-86cb-8a0ba62dae92'
    Definition: 'Contributor'
    subscriptionId: 'ae9c7f6f-a353-46c0-92f5-2528f400cf3e'
  }
  {
    PrincipalId: '876e0fde-3b6f-445a-a021-d68e0d697be5'
    Definition: 'Owner'
    subscriptionId: 'deacbeef-c2bd-4137-801f-94a49c82779f'
  }
  {
    PrincipalId: '79bfb352-d85b-4865-9390-22bd0e5cf5cb'
    Definition: 'User Access Administrator'
    subscriptionId: 'deacbeef-c2bd-4137-801f-94a49c82779f'
  }
  {
    PrincipalId: 'b7ae3048-1fe5-4163-b689-79b06756f929'
    Definition: 'Contributor'
    subscriptionId: 'deacbeef-c2bd-4137-801f-94a49c82779f'
  }
  {
    PrincipalId: 'aa2840c6-e674-4f55-be49-22b5e76c08c9'
    Definition: 'Owner'
    subscriptionId: '74946a32-3571-405a-8896-a7a275185cb1'
  }
  {
    PrincipalId: '6fb952f9-5584-4e0d-932b-c14bacdfaa5f'
    Definition: 'Owner'
    subscriptionId: '45557548-0250-482a-8766-65cd8d44958f'
  }
  {
    PrincipalId: '352eb8d8-73f7-4939-a8b7-5b4bdba9e056'
    Definition: 'Owner'
    subscriptionId: '853733c6-bb75-4f92-bc85-00f9966cde79'
  }
  {
    PrincipalId: 'b0bb99ab-2f6e-4a6d-a1bc-8513937fc7a5'
    Definition: 'Reader'
    subscriptionId: '853733c6-bb75-4f92-bc85-00f9966cde79'
  }
  {
    PrincipalId: '6e2bf478-441b-4568-985b-74f29c90bd63'
    Definition: 'Contributor'
    subscriptionId: '853733c6-bb75-4f92-bc85-00f9966cde79'
  }
  {
    PrincipalId: '68db32f8-7177-4cd7-af62-9da34eb3cdd8'
    Definition: 'Key Vault Administrator'
    subscriptionId: '853733c6-bb75-4f92-bc85-00f9966cde79'
  }
  {
    PrincipalId: '4f74653e-905f-4a03-a968-5ba0df70d761'
    Definition: 'Owner'
    subscriptionId: 'ebaab79e-7cee-4de1-bbba-56ff652b7d93'
  }
  {
    PrincipalId: 'afd0cea4-3ae0-4687-b9bc-eec67526919f'
    Definition: 'Contributor'
    subscriptionId: 'ebaab79e-7cee-4de1-bbba-56ff652b7d93'
  }
  {
    PrincipalId: 'f5f8dc42-5096-4a94-9dfb-94bb3d5230a0'
    Definition: 'Owner'
    subscriptionId: '4088c57a-4e6e-40e9-a1f6-af63a76d52e0'
  }
  {
    PrincipalId: '77299d04-e5d7-4243-87e6-4543df55840f'
    Definition: 'Owner'
    subscriptionId: 'c53b6023-5414-46ca-a7e8-87663d584ecb'
  }
  {
    PrincipalId: 'a7602c31-0dce-4907-820c-b218aed7abeb'
    Definition: 'Owner'
    subscriptionId: 'dc22e1fa-2cdc-4b89-b930-a53af6d7fb29'
  }
  {
    PrincipalId: 'e925e583-765a-4806-9e83-d50a1406ac7b'
    Definition: 'Reader'
    subscriptionId: '19c01d83-6579-41cb-99f6-86a85ed772f4'
  }
  {
    PrincipalId: '474d2a8d-0a21-4550-b3c7-e1220b13587d'
    Definition: 'IoT Hub Data Reader'
    subscriptionId: '19c01d83-6579-41cb-99f6-86a85ed772f4'
  }
  {
    PrincipalId: '233c3403-c4a4-446a-85a0-c45ba5fa02b7'
    Definition: 'Contributor'
    subscriptionId: '19c01d83-6579-41cb-99f6-86a85ed772f4'
  }
  {
    PrincipalId: '241ac12c-a90c-4865-a17e-49007da98410'
    Definition: 'User Access Administrator'
    subscriptionId: '42815d43-a0cf-4856-8d75-2db574232f48'
  }
  {
    PrincipalId: '0f0ecb0f-bc2c-4564-a0bf-c43c3bd07434'
    Definition: 'Contributor'
    subscriptionId: '42815d43-a0cf-4856-8d75-2db574232f48'
  }
  {
    PrincipalId: 'a29bb002-4160-4412-926c-c3cf5e98b17b'
    Definition: 'Reader'
    subscriptionId: '42815d43-a0cf-4856-8d75-2db574232f48'
  }
  {
    PrincipalId: 'edbd44de-9ba4-40d1-9231-6f16fc40eda4'
    Definition: 'Contributor'
    subscriptionId: 'f5a3f798-8209-4031-a041-ffb9f36f39bb'
  }
  {
    PrincipalId: 'b6b239be-9f64-4e64-828f-0dfe139de168'
    Definition: 'Reader'
    subscriptionId: 'f5a3f798-8209-4031-a041-ffb9f36f39bb'
  }
  {
    PrincipalId: '2b845e68-3062-45cc-8830-4b90474d845f'
    Definition: 'Owner'
    subscriptionId: 'f5a3f798-8209-4031-a041-ffb9f36f39bb'
  }
  {
    PrincipalId: 'cbf84a15-eb4e-4816-a45c-0e7aa7855573'
    Definition: 'Owner'
    subscriptionId: '6666fbed-fb74-4852-972a-b6f2f2244c13'
  }
  {
    PrincipalId: '4546966e-bbeb-417c-8ea8-3220a528f44d'
    Definition: 'Contributor'
    subscriptionId: '6666fbed-fb74-4852-972a-b6f2f2244c13'
  }
  {
    PrincipalId: 'da39ad14-57c7-417c-ad94-d0278da1644b'
    Definition: 'Owner'
    subscriptionId: 'ec361111-d411-40cf-866f-96010dee7352'
  }
  {
    PrincipalId: '58372f18-61ba-4179-bc50-9e0be7a7cb60'
    Definition: 'Contributor'
    subscriptionId: 'ec361111-d411-40cf-866f-96010dee7352'
  }
  {
    PrincipalId: '31700377-8c65-48a5-b3ee-dbbb9a0bf7c7'
    Definition: 'Owner'
    subscriptionId: 'f80bd448-1159-432a-9f1a-f815d2b5850b'
  }
  {
    PrincipalId: '040becc5-1b5b-4154-a769-616f63a5b996'
    Definition: 'Contributor'
    subscriptionId: 'f80bd448-1159-432a-9f1a-f815d2b5850b'
  }
  {
    PrincipalId: '8d9c538e-c6d5-44d6-a2c0-26fb48476245'
    Definition: 'Reader'
    subscriptionId: 'f80bd448-1159-432a-9f1a-f815d2b5850b'
  }
  {
    PrincipalId: 'b97b920f-dd19-4035-af4b-09901cd3fc5a'
    Definition: 'Contributor'
    subscriptionId: '908f2831-426e-4428-a4ed-118893be1a17'
  }
  {
    PrincipalId: 'f6dbeef4-461a-4e3d-a524-686d453e3cbf'
    Definition: 'Owner'
    subscriptionId: '908f2831-426e-4428-a4ed-118893be1a17'
  }
  {
    PrincipalId: '5e929889-09c7-4339-910a-6a55fdf5b056'
    Definition: 'Reader'
    subscriptionId: '908f2831-426e-4428-a4ed-118893be1a17'
  }
]
