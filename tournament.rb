class Round
    
    def initialize(participants, rn)
        @array = Array.new(participants).fill(@@free)
        @users = participants
        @round_number = rn;
    end
    
    def round_at(x)
        @bracket[x]
    end
    
    def reverse
        @array = @array.reverse
    end
    
    def to_s
        s = ""
        for x in (0...@users)
            s << @array[x].to_s
            
            if (x%2==0 && @users!=1)
                s << "|"
                elsif (x!=@users-1)
                s << ", "
                elsif (@users==1)
                #s << "!"
            end
        end
        s
    end
    
    def round_number
        @round_number
    end
    
    def insert(user,x)
        @array[x]=user
    end
    
    def inserts(users)
        for x in (0...users.length)
            insert(users[x],x)
        end
    end
    
    def user_at(x)
        @array[x]
    end
    
    def length
        @users
    end
    
    def matchups
        for x in (0...@users)
            puts @array[x].to_s+ "'s opponent is "+ @array[x].get_opponent(self).to_s
        end
        puts "--------------"
    end
    
end

class User
    
    def initialize(n,p)
        @name = n
        @pos = [p]
    end
    
    def to_s
        "\033[92m" + @name + "\033[0m"
    end
    
    def is_active?(round)
        round_number==round
    end
    
    def last_pos
        @pos[-1]
    end
    
    def round_number
        @pos.length-1
    end
    
    def advance
        @pos.push((@pos[-1]/2).floor)
    end
    
    def devance
        @pos.pop
    end
    
    def get_opponent(round)
        if (round.round_number>round_number || round.length==1)
            @@free
        elsif (last_pos%2==0)
            round.user_at(@pos[round.round_number].to_i+1)
        else
            round.user_at(@pos[round.round_number].to_i-1)
        end
    end
    
end

class Bracket
    
    def initialize(c)
        @round_number=0;
        @bracket = []
        while (c!=0)
            @bracket.push(Round.new(c, @bracket.length))
            c /= 2
        end
    end
    
    def round_at(x)
        @bracket[x]
    end
    
    def to_s
        s = "--------------\n Best of "+(@bracket[0].length).to_s+"\n--------------\n"
        for x in (0...@bracket.length)
            if (x!=@bracket.length-1)
                s << "Round " + (x+1).to_s << ": " + @bracket[x].to_s + "\n"
                else
                s << "Winner: " + @bracket[x].to_s + "\n"
            end
        end
        s << "--------------"
    end
    
    def load(users)
        @bracket[0].inserts(users)
    end
    
    def current_round
        @bracket[@round_number]
    end
    
    def round_plus
        @round_number+=1
    end
    
    def round_minus
        @round_number-=1
    end
    
    def advance(user)
        user.advance
        puts "Advancing "+user.to_s+" to round "+(user.round_number+1).to_s
        @bracket[user.round_number].insert(user,user.last_pos)
    end
    
    def matchups(x)
        round_at(x).matchups
    end
    
    def print_adv(rn)
        puts "\033[35m\n=============================================\nADVANCING TO ROUND "+(rn+2).to_s + "\n=============================================\033[0m"
    end
    
    def advances(array, rn)
        array.each do |item| 
           advance(@bracket[rn].user_at(item))
        end
        round_plus
        #@bracket[rn+1].reverse
        print_adv(rn)
    end
end

def make_users(u)
    users = []
    total = u.length
    for x in (0...u.length)
        users.push(User.new(u.pop,total-1-x))
    end
    users.reverse
end

@@free = User.new("\033[91mnil\033[0m",nil)

winners = Bracket.new(16)
# Best of 16

#users = make_users(["Marty","Samantha","Carlos","Michelangelo"])
#users = make_users(ARGV)
users = make_users(["Forbad","Sublimate","Natengall","Gooshy","GuruMooster","Fallout","Jabberwock","Kallistosx","Whitewing","Toofaraway","bonesaw","Revolve","Diclkrunk","Jedwin","Sherman","RadishSpirit"])

winners.load(users)

winners.print_adv(-1)

puts(winners.to_s)
winners.matchups(0)

winners.advances([0,2,4,6,9,11,12,14],0)

puts(winners.to_s)
winners.matchups(1)

winners.advances([1,2,4,7],1)

puts(winners.to_s)
winners.matchups(2)

winners.advances([0,2],2)

puts(winners.to_s)
winners.matchups(3)

winners.advance(users[9])  #advance toofaraway manually
winners.print_adv(3)
winners.round_plus

puts(winners.to_s)
winners.matchups(4)

print "And the winner is... ",winners.current_round.user_at(0).to_s ,"!\n"


#winners.load(users)
#puts winners.to_s
#winners.matchups(0)
#
#winners.advance(users[0])
#winners.advance(users[3])
#puts winners.to_s
#winners.matchups(1)
#
#winners.advance(users[3])
#puts winners.to_s
#winners.matchups(2)
#
