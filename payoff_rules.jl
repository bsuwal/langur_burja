""" payoff_rules.jl
"""

function payoff_rule_1(num_succs::Int)
    """ Returns the payoff when there are ``num_succs" dice that are of the player's chosen symbol.

        Example:
        Num symbols -> Payoff
        0 -> -1
        1 -> -1
        2 -> 2
        ...
        6 -> 6
    """
    @assert num_succs >= 0

    if num_succs <= 1
        -1
    else
        num_succs
    end
end

function payoff_rule_2(num_succs::Int)
    """ Lenient bot firta
        This is the Alternate Scheme 1 in the blog post.

        Example:
        Num symbols -> Payoff
        0 -> -1
        1 -> 0   ("bot firta")
        2 -> 2
        ...
        6 -> 6
    """
    @assert num_succs >= 0

    if num_succs == 0
        -1
    elseif num_succs == 1
        0
    else
        num_succs
    end
end

function payoff_rule_3(num_succs::Int)
    """ Strict bot firta

        This is the alternate scheme 2 in the blog post.

        Example:
        Num symbols -> Payoff
        0 -> -1
        1 -> 0   ("bot firta")
        2 -> 1
        ...
        6 -> 5
    """
    @assert num_succs >= 0

    if num_succs == 0
        -1
    else
        num_succs-1
    end
end


function payoff_rule_4(num_succs::Int)
    """ This is the alternate scheme 3 in the blog post.

        Example:
        Num symbols -> Payoff
        0 -> -1
        1 -> 1
        2 -> 2
        ...
        6 -> 6
    """
    @assert num_succs >= 0

    if num_succs == 0
        -1
    else
        num_succs
    end
end

function payoff_amount(N::Int,
                       F::Int,
                       num_succs::Int,
                       payoff_rule::Function,
                       house_return::Bool=false)
    """ num_succs is the number of success events i.e the number of times the Player's symbol shows up in the round.
    """
    succ = 1/F
    fail = 1 - succ

    # Return = Payoff + Bet Amount
    if house_return
        (payoff_rule(num_succs)+1) * binomial(N ,num_succs) * succ^num_succs * fail^(N-num_succs)
    else
        payoff_rule(num_succs) * binomial(N ,num_succs) * succ^num_succs * fail^(N-num_succs)
    end
end

function expected_payoff(N::Int,
                         F::Int,
                         payoff_rule::Function,
                         house_return::Bool=false)
    """ Returns the expected payoff.
    """
    payoff_sum = 0

    # num_succs is the number of successes i.e num dice that show the symbol player has chosen
    for num_succs = 0:N
        payoff_sum += payoff_amount(N, F, num_succs, payoff_rule, house_return)
    end
    payoff_sum
end
