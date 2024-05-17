filter New-GitHubOrganizationInvite {
    <#
        .SYNOPSIS
        Create an organization invite.

        .DESCRIPTION
        Invite people to an organization by using their GitHub user ID or their email address. In order to create invitations in an organization, the authenticated user must be an organization owner.

        .EXAMPLE
        New-GitHubOrganizationInvite -OrganizationName 'PSModule' -UserName 'octocat'

        Invites the octocat user to the PSModule organization.

        .EXAMPLE
        New-GitHubOrganizationInvite -OrganizationName 'PSModule' -UserName 'octocat' -Role admin

        Invites the octocat user to the PSModule organization as an admin.

        .EXAMPLE
        New-GitHubOrganizationInvite -OrganizationName 'PSModule' -EmailAddress 'octocat@github.com'

        Sends an invitation email to octocat@github.com to invite them to the PSModule organization.

        .NOTES
        [Create an organization invite](https://docs.github.com/en/rest/orgs/members)
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param (
        # The organization name. The name is not case sensitive.
        [Parameter(
            Mandatory,
            ParameterSetName = 'byUserName',
            ValueFromPipelineByPropertyName
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'byEmailAddress',
            ValueFromPipelineByPropertyName
        )]
        [Alias('login')]
        [Alias('org')]
        [Alias('owner')]
        [string] $OrganizationName,

        [Parameter(
            Mandatory,
            ParameterSetName = 'byUserName',
            ValueFromPipelineByPropertyName
        )]
        [string]$UserName,

        [Parameter(
            Mandatory,
            ParameterSetName = 'byEmailAddress',
            ValueFromPipelineByPropertyName
        )]
        [string]$EmailAddress,


        [ValidateSet('direct_member', 'admin', 'billing_manager', 'reinstate')]
        [string]$Role = 'direct_member'
    )

    switch ($PSCmdlet.ParameterSetName) {
        'byUserName' {
            $body = @{
                invitee_id = (Get-GitHubUser -Username $UserName).id
                role       = $Role
            }
        }
        'byEmailAddress' {
            $body = @{
                email = $EmailAddress
                role  = $Role
            }
        }
    }

    $inputObject = @{
        APIEndpoint = "/orgs/$OrganizationName/invitations"
        Method      = 'post'
        Body        = $body
    }

    Invoke-GitHubAPI @inputObject | ForEach-Object {
        Write-Output $_.Response
    }
}
